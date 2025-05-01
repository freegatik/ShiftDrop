//
//  APIConfiguration.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import Foundation

enum APIConfiguration {
    private static let fallback = "https://shift-backend.onrender.com/"

    static var baseURLString: String {
        let raw = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? fallback
        return raw.hasSuffix("/") ? raw : raw + "/"
    }
}
