//
//  URLSessionDeliveryAPI.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import Foundation

final class URLSessionDeliveryAPI: DeliveryAPIService, @unchecked Sendable {
    private let baseURLString: String
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        baseURLString: String = APIConfiguration.baseURLString,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.baseURLString = baseURLString
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetchDeliveryPoints() async throws -> DeliveryPointsResponse {
        try await request(.points)
    }

    func fetchPackageTypes() async throws -> DeliveryPackageTypesResponse {
        try await request(.types)
    }

    func calculateDelivery(_ requestBody: DeliveryCalcRequest) async throws -> DeliveryCalcResponse {
        try await request(.calc(body: requestBody))
    }

    func placeOrder(_ requestBody: DeliveryOrderRequest) async throws -> DeliveryOrderResponse {
        try await request(.order(body: requestBody))
    }

    // MARK: - Private

    private enum Endpoint {
        case points
        case types
        case calc(body: DeliveryCalcRequest)
        case order(body: DeliveryOrderRequest)

        var path: String {
            switch self {
            case .points: return "delivery/points"
            case .types: return "delivery/package/types"
            case .calc: return "delivery/calc"
            case .order: return "delivery/order"
            }
        }

        var method: String {
            switch self {
            case .points, .types: return "GET"
            case .calc, .order: return "POST"
            }
        }
    }

    private func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlString = baseURLString + endpoint.path
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method

        switch endpoint {
        case .points, .types:
            break
        case .calc(let body):
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                urlRequest.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.encodingFailed
            }
        case .order(let body):
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                urlRequest.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.encodingFailed
            }
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw NetworkError.transport(error)
        }

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NetworkError.httpStatus(code: http.statusCode)
        }

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
