//
//  TabBarSource.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class TabBarSource: NSObject, UITabBarControllerDelegate, UITabBarDelegate {
    
    static let shared = TabBarSource()
    
    var tabBarController: UITabBarController?
    
    func setupForTabBarController(_ tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        
        
    }
    
}
