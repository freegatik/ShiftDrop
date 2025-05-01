//
//  DeliveryInformation.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 04.05.2025.
//

struct DeliveryInformation {
    
    var senderPoint: Point? = Point(id: "1", name: "Москва", latitude: 55.7558, longitude: 37.6173)
    var receiverPoint: Point? = Point(id: "2", name: "Санкт-Петербург", latitude: 59.9343, longitude: 30.3351)
    var packageType: Package? = Package(id: "1", name: "Конверт", length: 42, width: 36, weight: 2, height: 5)
    var deliveryType: String?
    var deliveryPrice: Int?
    var deliveryTime: Int?
    
    var receiver: Person?
    var sender: Person?
    
    var whoPay: String?
    
    var id: String?
    var name: String?
}
