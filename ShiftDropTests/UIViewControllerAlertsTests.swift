//
//  UIViewControllerAlertsTests.swift
//  ShiftDropTests
//
//  Created by Anton Solovev on 11.05.2026.
//

import XCTest
@testable import ShiftDrop

@MainActor
final class UIViewControllerAlertsTests: XCTestCase {

    func testPresentUserAlertPresentsAlertController() throws {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let vc = UIViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        vc.loadViewIfNeeded()

        let exp = expectation(description: "present")
        vc.presentUserAlert(message: "hello")
        DispatchQueue.main.async {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)

        let alert = try XCTUnwrap(vc.presentedViewController as? UIAlertController)
        XCTAssertEqual(alert.message, "hello")
        XCTAssertEqual(alert.actions.count, 1)
    }
}
