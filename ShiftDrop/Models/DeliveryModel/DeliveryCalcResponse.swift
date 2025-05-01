//
//  DeliveryCalcResponse.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 08.05.2025.
//

import Foundation

struct DeliveryCalcResponse: Decodable {
    let success: Bool
    let reason: String?
    let options: [Options]
}

struct Options: Decodable {
    let id: String
    let days: Int
    let price: Int
    let name: String
    let type: String
}


