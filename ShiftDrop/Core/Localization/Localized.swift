//
//  Localized.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import Foundation

enum Localized {
    static let tabCalculation = String(localized: "tab.calculation", defaultValue: "Расчёт")
    static let tabHistory = String(localized: "tab.history", defaultValue: "История")
    static let tabProfile = String(localized: "tab.profile", defaultValue: "Профиль")

    static let calcTitle = String(localized: "calc.title", defaultValue: "Рассчитать доставку")
    static let calcAction = String(localized: "calc.action", defaultValue: "Рассчитать")
    static let historyPlaceholder = String(localized: "history.placeholder", defaultValue: "В разработке…")
    static let profilePlaceholder = String(localized: "profile.placeholder", defaultValue: "В разработке…")

    static let errorGeneric = String(localized: "error.generic", defaultValue: "Что-то пошло не так")
    static let errorOk = String(localized: "error.ok", defaultValue: "Ок")
    static let orderValidationFailed = String(localized: "order.validation", defaultValue: "Заполните все поля заказа")
}
