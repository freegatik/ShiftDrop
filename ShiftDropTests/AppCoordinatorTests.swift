//
//  AppCoordinatorTests.swift
//  ShiftDropTests
//
//  Created by Anton Solovev on 11.05.2026.
//

import XCTest
@testable import ShiftDrop

@MainActor
final class AppCoordinatorTests: XCTestCase {

    func testStartInstallsTabBarWithThreeTabs() throws {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        let deps = AppDependencies(
            api: MockDeliveryAPIService(),
            logger: CapturingLogger()
        )
        let coordinator = AppCoordinator(window: window, dependencies: deps)
        coordinator.start()

        let root = try XCTUnwrap(window.rootViewController as? UITabBarController)
        XCTAssertEqual(root.viewControllers?.count, 3)
        XCTAssertTrue(root.viewControllers?[0] is ViewController)
        XCTAssertTrue(root.viewControllers?[1] is SecondViewController)
        XCTAssertTrue(root.viewControllers?[2] is ThirdViewController)
        XCTAssertEqual(root.selectedIndex, 0)
        XCTAssertNotNil(root.tabBar.items?[0].title)
        XCTAssertNotNil(root.tabBar.items?[1].title)
        XCTAssertNotNil(root.tabBar.items?[2].title)
    }
}
