//
//  DeliveryCalcRequest.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 07.05.2025.
//

import Foundation

struct DeliveryCalcRequest: Encodable {
    var package: PackageRequest
    var senderPoint: PointRequest
    var receiverPoint: PointRequest
}

struct PackageRequest: Encodable {
    let length: Int
    let width: Int
    let weight: Int
    let height: Int
}

struct PointRequest: Encodable {
    let latitude: Double
    let longitude: Double
}
