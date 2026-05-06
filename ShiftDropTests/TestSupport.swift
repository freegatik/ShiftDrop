import Foundation
import XCTest
@testable import ShiftDrop

// MARK: - URL mock

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

enum TestHTTPBody {
    /// URLSession often forwards POST bodies via `httpBodyStream`; `httpBody` may be nil in `URLProtocol`.
    static func data(from request: URLRequest) -> Data? {
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
}

// MARK: - API mock

enum MockDeliveryAPIFixtures {
    static func emptyPoints() throws -> DeliveryPointsResponse {
        let data = """
        {"success":true,"reason":null,"points":[]}
        """.data(using: .utf8)!
        return try JSONDecoder().decode(DeliveryPointsResponse.self, from: data)
    }

    static func emptyPackages() throws -> DeliveryPackageTypesResponse {
        let data = """
        {"success":true,"reason":null,"packages":[]}
        """.data(using: .utf8)!
        return try JSONDecoder().decode(DeliveryPackageTypesResponse.self, from: data)
    }

    static func sampleOrder() throws -> DeliveryOrderResponse {
        let data = """
        {"success":true,"reason":null,"order":{"status":1,"cancellable":true}}
        """.data(using: .utf8)!
        return try JSONDecoder().decode(DeliveryOrderResponse.self, from: data)
    }

    static func sampleTwoPoints() throws -> DeliveryPointsResponse {
        let data = """
        {"success":true,"reason":null,"points":[
          {"id":"1","name":"Москва","latitude":55.7558,"longitude":37.6173},
          {"id":"2","name":"Санкт-Петербург","latitude":59.9343,"longitude":30.3351}
        ]}
        """.data(using: .utf8)!
        return try JSONDecoder().decode(DeliveryPointsResponse.self, from: data)
    }

    static func sampleTwoPackages() throws -> DeliveryPackageTypesResponse {
        let data = """
        {"success":true,"reason":null,"packages":[
          {"id":"1","name":"Конверт","length":42,"width":36,"weight":2,"height":5},
          {"id":"2","name":"Коробка","length":30,"width":20,"weight":5,"height":15}
        ]}
        """.data(using: .utf8)!
        return try JSONDecoder().decode(DeliveryPackageTypesResponse.self, from: data)
    }
}

final class MockDeliveryAPIService: DeliveryAPIService, @unchecked Sendable {
    var fetchDeliveryPointsImpl: @Sendable () async throws -> DeliveryPointsResponse
    var fetchPackageTypesImpl: @Sendable () async throws -> DeliveryPackageTypesResponse
    var calculateDeliveryImpl: @Sendable (DeliveryCalcRequest) async throws -> DeliveryCalcResponse
    var placeOrderImpl: @Sendable (DeliveryOrderRequest) async throws -> DeliveryOrderResponse

    init(
        fetchDeliveryPoints: @escaping @Sendable () async throws -> DeliveryPointsResponse = {
            try await Task.sleep(nanoseconds: 0)
            return try MockDeliveryAPIFixtures.emptyPoints()
        },
        fetchPackageTypes: @escaping @Sendable () async throws -> DeliveryPackageTypesResponse = {
            try await Task.sleep(nanoseconds: 0)
            return try MockDeliveryAPIFixtures.emptyPackages()
        },
        calculateDelivery: @escaping @Sendable (DeliveryCalcRequest) async throws -> DeliveryCalcResponse = { _ in
            try await Task.sleep(nanoseconds: 0)
            return try MockDeliveryAPIService.sampleCalcResponse()
        },
        placeOrder: @escaping @Sendable (DeliveryOrderRequest) async throws -> DeliveryOrderResponse = { _ in
            try await Task.sleep(nanoseconds: 0)
            return try MockDeliveryAPIFixtures.sampleOrder()
        }
    ) {
        self.fetchDeliveryPointsImpl = fetchDeliveryPoints
        self.fetchPackageTypesImpl = fetchPackageTypes
        self.calculateDeliveryImpl = calculateDelivery
        self.placeOrderImpl = placeOrder
    }

    func fetchDeliveryPoints() async throws -> DeliveryPointsResponse {
        try await fetchDeliveryPointsImpl()
    }

    func fetchPackageTypes() async throws -> DeliveryPackageTypesResponse {
        try await fetchPackageTypesImpl()
    }

    func calculateDelivery(_ request: DeliveryCalcRequest) async throws -> DeliveryCalcResponse {
        try await calculateDeliveryImpl(request)
    }

    func placeOrder(_ request: DeliveryOrderRequest) async throws -> DeliveryOrderResponse {
        try await placeOrderImpl(request)
    }

    /// Shared fixture: usual + express options (same order as production API).
    static func sampleCalcResponse() throws -> DeliveryCalcResponse {
        let data = """
        {"success":true,"reason":null,"options":[
          {"id":"a","days":3,"price":100,"name":"Обычная","type":"DEFAULT"},
          {"id":"b","days":1,"price":500,"name":"Экспресс","type":"EXPRESS"}
        ]}
        """.data(using: .utf8)!
        return try JSONDecoder().decode(DeliveryCalcResponse.self, from: data)
    }
}

// MARK: - Logger

final class CapturingLogger: AppLogging, @unchecked Sendable {
    private let lock = NSLock()
    private(set) var entries: [(LogLevel, String, String)] = []

    func log(_ level: LogLevel, category: String, _ message: String) {
        lock.lock()
        entries.append((level, category, message))
        lock.unlock()
    }

    func snapshot() -> [(LogLevel, String, String)] {
        lock.lock()
        let copy = entries
        lock.unlock()
        return copy
    }
}

// MARK: - JSONEncoder that fails (encodingFailed path)

final class ThrowingJSONEncoder: JSONEncoder, @unchecked Sendable {
    override func encode<T: Encodable>(_ value: T) throws -> Data {
        throw CocoaError(.coderInvalidValue)
    }
}
