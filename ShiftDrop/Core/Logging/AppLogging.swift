//
//  AppLogging.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import Foundation
import OSLog

enum LogLevel: Int, Comparable {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3

    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

protocol AppLogging: Sendable {
    func log(_ level: LogLevel, category: String, _ message: String)
}

extension AppLogging {
    func debug(_ category: String, _ message: String) { log(.debug, category: category, message) }
    func info(_ category: String, _ message: String) { log(.info, category: category, message) }
    func warning(_ category: String, _ message: String) { log(.warning, category: category, message) }
    func error(_ category: String, _ message: String) { log(.error, category: category, message) }
}

final class ConsoleLogger: AppLogging, @unchecked Sendable {
    private let subsystem: String
    private let minLevel: LogLevel

    init(subsystem: String = Bundle.main.bundleIdentifier ?? "ShiftDrop", minLevel: LogLevel = .info) {
        self.subsystem = subsystem
        self.minLevel = minLevel
    }

    func log(_ level: LogLevel, category: String, _ message: String) {
        guard level >= minLevel else { return }
        let logger = Logger(subsystem: subsystem, category: category)
        switch level {
        case .debug: logger.debug("\(message, privacy: .public)")
        case .info: logger.info("\(message, privacy: .public)")
        case .warning: logger.warning("\(message, privacy: .public)")
        case .error: logger.error("\(message, privacy: .public)")
        }
    }
}
