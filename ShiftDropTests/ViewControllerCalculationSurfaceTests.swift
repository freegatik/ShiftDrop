//
//  ViewControllerCalculationSurfaceTests.swift
//  ShiftDropTests
//
//  Created by Anton Solovev on 11.05.2026.
//

import XCTest
@testable import ShiftDrop

@MainActor
final class ViewControllerCalculationSurfaceTests: XCTestCase {

    func testCalculationScreenSurfacesLocalizedCopy() {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = ViewController(dependencies: deps)
        vc.loadViewIfNeeded()

        XCTAssertEqual(vc.header.text, Localized.calcTitle)
        XCTAssertEqual(vc.calculateButton.title(for: .normal), Localized.calcAction)
        XCTAssertEqual(vc.calculateButton.accessibilityIdentifier, "calc.primaryAction")
    }

    func testDefaultPickersExposeSeedValues() {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = ViewController(dependencies: deps)
        vc.loadViewIfNeeded()

        XCTAssertEqual(vc.shippedFromView.testDisplayedValue, "Москва")
        XCTAssertEqual(vc.shippedToView.testDisplayedValue, "Санкт-Петербург")
        XCTAssertEqual(vc.packageSizeView.testDisplayedValue, "Конверт")
    }
}
