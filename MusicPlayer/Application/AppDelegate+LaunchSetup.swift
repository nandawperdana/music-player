//
//  AppDelegate+LaunchSetup.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import UIKit
import Api

extension AppDelegate {
    func launchSetup() {
        Api.initInstance(apiBasePath: Constant.apiBasePath)
        setupInitialScreen()
    }
    
    func setupInitialScreen() {
        let musicListVC = MusicListViewController()
        musicListVC.title = "Music App"
        
        UINavigationBar.appearance().tintColor = .gray
        
        let navController = UINavigationController(rootViewController: musicListVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .clear
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
