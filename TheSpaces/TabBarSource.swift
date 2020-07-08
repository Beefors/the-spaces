//
//  TabBarSource.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class TabBarSource: NSObject, UITabBarControllerDelegate {
    
    static let shared = TabBarSource()
    
    var tabBarController: UITabBarController!
    
    func setupForTabBarController(_ tabBarController: TabbarController) {
        self.tabBarController = tabBarController
        
        tabBarController.customHeight = 65
        tabBarController.tabBar.tintColor = UIColor.STGraphite
        tabBarController.tabBar.unselectedItemTintColor = UIColor.STGray
        tabBarController.tabBar.isTranslucent = false
        tabBarController.delegate = TabBarSource.shared
        
        setupControllers()
    }
    
    private func setupControllers() {
        
        func buildNavController(coordinator: Coordinator, title: String, tabbarIcon: UIImage) -> UINavigationController {
            let navController = UINavigationController(rootViewController: coordinator.viewController)
            navController.tabBarItem = UITabBarItem(title: title,
                                                    image: tabbarIcon.withRenderingMode(.alwaysTemplate),
                                                    selectedImage: tabbarIcon.withRenderingMode(.alwaysOriginal))
            
            navController.tabBarItem.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
            navController.tabBarItem.setTitleTextAttributes([.font: UIFont.tabbarTitles], for: .normal)
            navController.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -7)
            
            return navController
        }
        
        let searchNavController = buildNavController(coordinator: SearchCoordinator.main, title: "Поиск", tabbarIcon: #imageLiteral(resourceName: "tabbarSearchIcon"))
        let placesNavController = buildNavController(coordinator: PlacesCoordinator.placesList, title: "Мои места", tabbarIcon: #imageLiteral(resourceName: "tabbarPlacesIcon"))
        let profileNavController = buildNavController(coordinator: ProfileCoordinator.profile, title: "Профиль", tabbarIcon: #imageLiteral(resourceName: "tabbarProfiletIcon"))
        let otherNavController = buildNavController(coordinator: OtherCoordinator.other, title: "Прочее", tabbarIcon: #imageLiteral(resourceName: "tabbarOtherIcon"))
        
        tabBarController.setViewControllers([searchNavController, placesNavController, profileNavController, otherNavController], animated: false)
        
        tabBarController.tabBar.bounds = CGRect(x: 0, y: 0, width: tabBarController.tabBar.bounds.width, height: 60)
    }
    
}

class TabbarController: UITabBarController {
    
    var customHeight: CGFloat?
    
    override func viewWillLayoutSubviews() {
        guard let customHeight = customHeight else { return }
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = customHeight
        tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height
        self.tabBar.frame = tabFrame
    }
    
}
