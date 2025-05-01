//
//  NetworkError.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case transport(Swift.Error)
    case noData
    case httpStatus(code: Int)
    case decodingFailed
    case encodingFailed

    var userFacingMessage: String {
        switch self {
        case .invalidURL:
            return String(localized: "error.network.bad_url", defaultValue: "Некорректный адрес сервера")
        case .transport:
            return String(localized: "error.network.transport", defaultValue: "Нет соединения с сервером")
        case .noData:
            return String(localized: "error.network.no_data", defaultValue: "Пустой ответ сервера")
        case .httpStatus(let code):
            return String(format: String(localized: "error.network.http_fmt", defaultValue: "Ошибка сервера (код %d)"), code)
        case .decodingFailed:
            return String(localized: "error.network.decode", defaultValue: "Не удалось разобрать ответ")
        case .encodingFailed:
            return String(localized: "error.network.encode", defaultValue: "Не удалось сформировать запрос")
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? { userFacingMessage }
}
