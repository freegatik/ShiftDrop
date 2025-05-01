//
//  DeliveryPackageTypesResponse.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 06.05.2025.
//

import Foundation

struct DeliveryPackageTypesResponse: Decodable {
    let success: Bool
    let reason: String?
    let packages: [Package]
}

struct Package: Decodable {
    let id: String
    let name: String
    let length: Int
    let width: Int
    let weight: Int
    let height: Int
}
