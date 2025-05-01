//
//  DeliveryPointsResponse.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 05.05.2025.
//

import Foundation

struct DeliveryPointsResponse: Decodable {
    let success: Bool
    let reason: String?
    let points: [Point]
}

struct Point: Decodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}
