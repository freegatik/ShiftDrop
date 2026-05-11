//
//  AppCoordinator.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 01.05.2025.
//

import UIKit

final class AppCoordinator {
    private let dependencies: AppDependencies
    private let window: UIWindow

    init(window: UIWindow, dependencies: AppDependencies) {
        self.window = window
        self.dependencies = dependencies
    }

    func start() {
        let calculation = ViewController(dependencies: dependencies)
        calculation.tabBarItem = UITabBarItem(
            title: Localized.tabCalculation,
            image: UIImage(named: "calculate.pdf"),
            tag: 0
        )
        calculation.tabBarItem.accessibilityIdentifier = "tab.calculation"

        let history = SecondViewController(dependencies: dependencies)
        history.tabBarItem = UITabBarItem(
            title: Localized.tabHistory,
            image: UIImage(named: "time.pdf"),
            tag: 1
        )
        history.tabBarItem.accessibilityIdentifier = "tab.history"

        let profile = ThirdViewController(dependencies: dependencies)
        profile.tabBarItem = UITabBarItem(
            title: Localized.tabProfile,
            image: UIImage(named: "user.pdf"),
            tag: 2
        )
        profile.tabBarItem.accessibilityIdentifier = "tab.profile"

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([calculation, history, profile], animated: false)
        tabBarController.selectedIndex = 0
        styleTabBar(tabBarController.tabBar)

        window.rootViewController = tabBarController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
    }

    private func styleTabBar(_ tabBar: UITabBar) {
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
    }
}
