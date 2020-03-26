//
//  SceneDelegate.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        var navigation = UINavigationController(rootViewController: AlbumTableViewController())
        
        #if DEBUG
        if UserDefaults.standard.bool(forKey: "MockNetwork") {
            let mockAlbumTableViewController = AlbumTableViewController(feedLoading: MockNetwork.mockLoading)
            navigation = UINavigationController(rootViewController: mockAlbumTableViewController)
        }
        #endif
        
        navigation.navigationBar.prefersLargeTitles = true
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = navigation
            self.window = window
            window.makeKeyAndVisible()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

