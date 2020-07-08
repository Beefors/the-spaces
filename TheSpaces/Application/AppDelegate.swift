//
//  AppDelegate.swift
//  TheSpaces
//
//  Created by Денис Швыров on 05.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit
import YandexMapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        application.applicationIconBadgeNumber = 0
        YMKMapKit.setApiKey("f0648490-ed8b-4f8a-a7fb-d741fbc016b4")
        
        RouterManager.shared.setup(forAppDelegate: self)
        
        return true
    }


}

