//
//  SceneDelegate.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 02.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let dependencies = AppDependencies.production()
        let coordinator = AppCoordinator(window: window, dependencies: dependencies)
        coordinator.start()

        self.window = window
    }
}


