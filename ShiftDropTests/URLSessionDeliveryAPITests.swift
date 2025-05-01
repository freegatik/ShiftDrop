import XCTest
@testable import ShiftDrop

final class MockURLProtocol: URLProtocol {

    nonisolated(unsafe) static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    static func reset() {
        handler = nil
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.handler else {
            XCTFail("MockURLProtocol.handler not set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

final class URLSessionDeliveryAPITests: XCTestCase {

    override func tearDown() {
        MockURLProtocol.reset()
        super.tearDown()
    }

    /// URLSession often forwards POST bodies via `httpBodyStream`; `httpBody` may be nil in `URLProtocol`.
    private static func httpBodyData(from request: URLRequest) -> Data? {
        if let body = request.httpBody, !body.isEmpty {
            return body
        }
        guard let stream = request.httpBodyStream else {
            return nil
        }
        stream.open()
        defer { stream.close() }
        var data = Data()
        let bufferSize = 4096
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        while stream.hasBytesAvailable {
            let read = stream.read(&buffer, maxLength: bufferSize)
            if read > 0 {
                data.append(contentsOf: buffer.prefix(read))
            } else if read < 0 {
                return nil
            } else {
                break
            }
        }
        return data.isEmpty ? nil : data
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
            XCTAssertNotNil(URLSessionDeliveryAPITests.httpBodyData(from: request))
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
}
