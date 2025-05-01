//
//  AppDependencies.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import Foundation

struct AppDependencies: Sendable {
    let api: DeliveryAPIService
    let logger: AppLogging

    static func production() -> AppDependencies {
        AppDependencies(
            api: URLSessionDeliveryAPI(),
            logger: ConsoleLogger(minLevel: .info)
        )
    }
}
