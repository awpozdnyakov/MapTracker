//
//  SceneDelegate.swift
//  MapTracker
//
//  Created by Andrey Pozdnyakov on 17.11.2023.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { fatalError("No one window scene exists") }

        window = UIWindow(windowScene: windowScene)

        let swiftUIView = MainScreenView()

        window?.rootViewController = UIHostingController(rootView: swiftUIView)
        window?.makeKeyAndVisible()
    }
}
