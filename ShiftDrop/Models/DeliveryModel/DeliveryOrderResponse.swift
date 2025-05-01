//
//  DeliveryOrderResponse.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 10.05.2025.
//

import Foundation

struct DeliveryOrderResponse: Decodable {
    let success: Bool
    let reason: String?
    let order: Order
}

struct Order: Decodable {
    let status: Int
    let cancellable: Bool
}
