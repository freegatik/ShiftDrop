//
//  DeliveryAPIService.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import Foundation

protocol DeliveryAPIService: Sendable {
    func fetchDeliveryPoints() async throws -> DeliveryPointsResponse
    func fetchPackageTypes() async throws -> DeliveryPackageTypesResponse
    func calculateDelivery(_ request: DeliveryCalcRequest) async throws -> DeliveryCalcResponse
    func placeOrder(_ request: DeliveryOrderRequest) async throws -> DeliveryOrderResponse
}
