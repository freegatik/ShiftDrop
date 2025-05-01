//
//  DeliveryOrderRequest.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 09.05.2025.
//

import Foundation

struct DeliveryOrderRequest: Encodable {
    let senderPoint: SenderPointRequest
    let senderAddress: SenderAddressRequest
    let sender: Sender
    let receiverPoint: ReceiverPointRequest
    let receiverAddress: ReceiverAddressRequest
    let receiver: Receiver
    let payer: String
    let option: OptionsRequest
}

struct SenderPointRequest: Encodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}

struct SenderAddressRequest: Encodable {
    let street: String
    let house: String
    let apartment: String?
    let comment: String?
}

struct Sender: Encodable {
    let firstname: String
    let lastname: String
    let middlename: String?
    let phone: String
}

struct ReceiverPointRequest: Encodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}

struct ReceiverAddressRequest: Encodable {
    let street: String
    let house: String
    let apartment: String?
    let comment: String?
}

struct Receiver: Encodable {
    let firstname: String
    let lastname: String
    let middlename: String?
    let phone: String
}

struct OptionsRequest: Encodable {
    let id: String
    let days: Int
    let price: Int
    let name: String
    let type: String
}
