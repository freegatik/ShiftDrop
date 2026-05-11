//
//  DeliveryDTOCodableTests.swift
//  ShiftDropTests
//
//  Created by Anton Solovev on 11.05.2026.
//

import XCTest
@testable import ShiftDrop

final class DeliveryDTOCodableTests: XCTestCase {

    func testDecodeDeliveryPointsResponse() throws {
        let data = """
        {"success":true,"reason":null,"points":[{"id":"1","name":"Москва","latitude":55.7558,"longitude":37.6173}]}
        """.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(DeliveryPointsResponse.self, from: data)
        XCTAssertTrue(decoded.success)
        XCTAssertEqual(decoded.points.count, 1)
        XCTAssertEqual(decoded.points[0].id, "1")
        XCTAssertEqual(decoded.points[0].name, "Москва")
    }

    func testDecodeDeliveryPackageTypesResponse() throws {
        let data = """
        {"success":true,"reason":null,"packages":[{"id":"x","name":"Конверт","length":42,"width":36,"weight":2,"height":5}]}
        """.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(DeliveryPackageTypesResponse.self, from: data)
        XCTAssertTrue(decoded.success)
        XCTAssertEqual(decoded.packages.count, 1)
        XCTAssertEqual(decoded.packages[0].weight, 2)
    }

    func testDecodeDeliveryCalcResponse() throws {
        let data = """
        {"success":true,"reason":null,"options":[
          {"id":"a","days":3,"price":100,"name":"Обычная","type":"DEFAULT"},
          {"id":"b","days":1,"price":500,"name":"Экспресс","type":"EXPRESS"}
        ]}
        """.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(DeliveryCalcResponse.self, from: data)
        XCTAssertEqual(decoded.options.count, 2)
        XCTAssertEqual(decoded.options[0].price, 100)
        XCTAssertEqual(decoded.options[1].type, "EXPRESS")
    }

    func testDecodeDeliveryOrderResponse() throws {
        let data = """
        {"success":true,"reason":null,"order":{"status":1,"cancellable":true}}
        """.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(DeliveryOrderResponse.self, from: data)
        XCTAssertTrue(decoded.success)
        XCTAssertEqual(decoded.order.status, 1)
        XCTAssertTrue(decoded.order.cancellable)
    }

    func testEncodeDeliveryCalcRequest_roundTripKeys() throws {
        let body = DeliveryCalcRequest(
            package: PackageRequest(length: 1, width: 2, weight: 3, height: 4),
            senderPoint: PointRequest(latitude: 55, longitude: 37),
            receiverPoint: PointRequest(latitude: 59, longitude: 30)
        )
        let encoded = try JSONEncoder().encode(body)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: encoded) as? [String: Any])
        XCTAssertNotNil(json["package"])
        XCTAssertNotNil(json["senderPoint"])
        XCTAssertNotNil(json["receiverPoint"])
    }
}
