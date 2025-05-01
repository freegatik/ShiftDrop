//
//  UIViewController+Alerts.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import UIKit

extension UIViewController {
    func presentUserAlert(title: String = Localized.errorGeneric, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localized.errorOk, style: .default))
        present(alert, animated: true)
    }
}
