//
//  AppDelegate.swift
//  Test Task
//
//  Created by Gleb Ilchyshyn on 08.02.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    let manager = NetworkManager.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        manager.requestIdList()
        return true
    }
}


