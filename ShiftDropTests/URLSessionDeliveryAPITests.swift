//
//  URLSessionDeliveryAPITests.swift
//  ShiftDropTests
//
//  Created by Anton Solovev on 11.05.2026.
//

import XCTest
@testable import ShiftDrop

final class URLSessionDeliveryAPITests: XCTestCase {

    override func tearDown() {
        MockURLProtocol.reset()
        super.tearDown()
    }

    private func sessionWithMock() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    func testFetchDeliveryPoints_GET_success() async throws {
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            let url = try XCTUnwrap(request.url?.absoluteString)
            XCTAssertTrue(url.hasSuffix("delivery/points"))
            let body = """
            {"success":true,"reason":null,"points":[]}
            """.data(using: .utf8)!
            let response = try XCTUnwrap(
                HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            )
            return (response, body)
        }
        let api = URLSessionDeliveryAPI(baseURLString: "https://example.test/", session: sessionWithMock())
        let result = try await api.fetchDeliveryPoints()
        XCTAssertTrue(result.success)
        XCTAssertTrue(result.points.isEmpty)
    }

    func testFetchDeliveryPoints_HTTP_error_mapsToNetworkError() async {
        MockURLProtocol.handler = { request in
            let body = Data()
            let response = HTTPURLResponse(url: request.url!, statusCode: 503, httpVersion: nil, headerFields: nil)!
            return (response, body)
        }
        let api = URLSessionDeliveryAPI(baseURLString: "https://example.test/", session: sessionWithMock())
        do {
            _ = try await api.fetchDeliveryPoints()
            XCTFail("expected throw")
        } catch let error as NetworkError {
            if case .httpStatus(let code) = error {
                XCTAssertEqual(code, 503)
            } else {
                XCTFail("wrong error \(error)")
            }
        } catch {
            XCTFail("unexpected \(error)")
        }
    }

    func testCalculateDelivery_POST_bodyAndJSON() async throws {
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertNotNil(TestHTTPBody.data(from: request))
            let body = """
            {"success":true,"reason":null,"options":[
              {"id":"a","days":3,"price":100,"name":"Обычная","type":"DEFAULT"},
              {"id":"b","days":1,"price":500,"name":"Экспресс","type":"EXPRESS"}
            ]}
            """.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, body)
        }
        let req = DeliveryCalcRequest(
            package: PackageRequest(length: 1, width: 2, weight: 3, height: 4),
            senderPoint: PointRequest(latitude: 55, longitude: 37),
            receiverPoint: PointRequest(latitude: 59, longitude: 30)
        )
        let api = URLSessionDeliveryAPI(baseURLString: "https://example.test/", session: sessionWithMock())
        let result = try await api.calculateDelivery(req)
        XCTAssertEqual(result.options.count, 2)
    }

    func testFetchPackageTypes_GET_success() async throws {
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertTrue(try XCTUnwrap(request.url?.absoluteString).hasSuffix("delivery/package/types"))
            let body = """
            {"success":true,"reason":null,"packages":[]}
            """.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, body)
        }
        let api = URLSessionDeliveryAPI(baseURLString: "https://example.test/", session: sessionWithMock())
        let result = try await api.fetchPackageTypes()
        XCTAssertTrue(result.success)
    }

    func testPlaceOrder_POST_body() async throws {
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertTrue(try XCTUnwrap(request.url?.absoluteString).hasSuffix("delivery/order"))
            XCTAssertNotNil(TestHTTPBody.data(from: request))
            let body = """
            {"success":true,"reason":null,"order":{"status":1,"cancellable":false}}
            """.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, body)
        }
        let order = DeliveryOrderRequest(
            senderPoint: SenderPointRequest(id: "1", name: "M", latitude: 1, longitude: 2),
            senderAddress: SenderAddressRequest(street: "s", house: "h", apartment: nil, comment: nil),
            sender: Sender(firstname: "A", lastname: "B", middlename: nil, phone: "0"),
            receiverPoint: ReceiverPointRequest(id: "2", name: "R", latitude: 3, longitude: 4),
            receiverAddress: ReceiverAddressRequest(street: "rs", house: "rh", apartment: nil, comment: nil),
            receiver: Receiver(firstname: "X", lastname: "Y", middlename: nil, phone: "9"),
            payer: "SENDER",
            option: OptionsRequest(id: "opt", days: 1, price: 10, name: "N", type: "DEFAULT")
        )
        let api = URLSessionDeliveryAPI(baseURLString: "https://example.test/", session: sessionWithMock())
        let result = try await api.placeOrder(order)
        XCTAssertTrue(result.success)
    }

    func testEmptyResponseBody_mapsToNoData() async {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let api = URLSessionDeliveryAPI(baseURLString: "https://example.test/", session: sessionWithMock())
        do {
            _ = try await api.fetchDeliveryPoints()
            XCTFail("expected throw")
        } catch let e as NetworkError {
            if case .noData = e {} else { XCTFail("\(e)") }
        } catch {
            XCTFail("\(error)")
        }
    }

    func testInvalidJSON_mapsToDecodingFailed() async {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, "{".data(using: .utf8)!)
        }
        let api = URLSessionDeliveryAPI(baseURLString: "https://example.test/", session: sessionWithMock())
        do {
            _ = try await api.fetchDeliveryPoints()
            XCTFail("expected throw")
        } catch let e as NetworkError {
            if case .decodingFailed = e {} else { XCTFail("\(e)") }
        } catch {
            XCTFail("\(error)")
        }
    }

    func testSessionTransport_mapsToTransport() async {
        MockURLProtocol.handler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        let api = URLSessionDeliveryAPI(baseURLString: "https://example.test/", session: sessionWithMock())
        do {
            _ = try await api.fetchDeliveryPoints()
            XCTFail("expected throw")
        } catch let e as NetworkError {
            if case .transport = e {} else { XCTFail("\(e)") }
        } catch {
            XCTFail("\(error)")
        }
    }

    func testInvalidBaseURL_mapsToInvalidURL() async {
        let api = URLSessionDeliveryAPI(
            baseURLString: "https://example.com\0/",
            session: sessionWithMock()
        )
        do {
            _ = try await api.fetchDeliveryPoints()
            XCTFail("expected throw")
        } catch let e as NetworkError {
            if case .invalidURL = e {} else { XCTFail("\(e)") }
        } catch {
            XCTFail("\(error)")
        }
    }

    func testEncodeFailure_mapsToEncodingFailed() async {
        let api = URLSessionDeliveryAPI(
            baseURLString: "https://example.test/",
            session: sessionWithMock(),
            encoder: ThrowingJSONEncoder()
        )
        let req = DeliveryCalcRequest(
            package: PackageRequest(length: 1, width: 2, weight: 3, height: 4),
            senderPoint: PointRequest(latitude: 55, longitude: 37),
            receiverPoint: PointRequest(latitude: 59, longitude: 30)
        )
        MockURLProtocol.handler = { request in
            XCTFail("should not reach network: \(request)")
            throw URLError(.badURL)
        }
        do {
            _ = try await api.calculateDelivery(req)
            XCTFail("expected throw")
        } catch let e as NetworkError {
            if case .encodingFailed = e {} else { XCTFail("\(e)") }
        } catch {
            XCTFail("\(error)")
        }
    }
}
