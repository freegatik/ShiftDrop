//
//  ShiftDropSmokeUITests.swift
//  ShiftDropUITests
//
//  Created by Anton Solovev on 11.05.2026.
//

import XCTest

final class ShiftDropSmokeUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }

    func testLaunchShowsCalculationTabAndPrimaryAction() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 8))

        let calcTab = tabBar.buttons["tab.calculation"]
        XCTAssertTrue(calcTab.waitForExistence(timeout: 3))
        XCTAssertTrue(calcTab.isSelected)

        let calculate = app.buttons["calc.primaryAction"]
        XCTAssertTrue(calculate.waitForExistence(timeout: 3))
        XCTAssertEqual(calculate.label, "Рассчитать")
    }

    func testTabBarSwitchesBetweenThreeSections() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 8))

        tabBar.buttons["tab.history"].tap()
        XCTAssertTrue(tabBar.buttons["tab.history"].waitForExistence(timeout: 2))

        tabBar.buttons["tab.profile"].tap()
        XCTAssertTrue(tabBar.buttons["tab.profile"].waitForExistence(timeout: 2))

        tabBar.buttons["tab.calculation"].tap()
        XCTAssertTrue(tabBar.buttons["tab.calculation"].isSelected)
    }

    func testCalculateOpensShippingSheet() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 8))

        app.buttons["calc.primaryAction"].tap()

        XCTAssertTrue(app.staticTexts["Способ отправки"].waitForExistence(timeout: 8))
    }
}
