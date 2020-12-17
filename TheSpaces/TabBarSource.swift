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
    private(set) var profileNavController: ProfileNavigationController!
    
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
        
        @discardableResult
        func buildNavController(navControllerType: UINavigationController.Type = UINavigationController.self, coordinator: Coordinator, title: String, tabbarIcon: UIImage) -> UINavigationController {
            let navController = navControllerType.init(rootViewController: coordinator.viewController)
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
        profileNavController = (buildNavController(navControllerType: ProfileNavigationController.self, coordinator: ProfileCoordinator.authorization, title: "Профиль", tabbarIcon: #imageLiteral(resourceName: "tabbarProfiletIcon")) as! ProfileNavigationController)
        let otherNavController = buildNavController(coordinator: OtherCoordinator.other, title: "Прочее", tabbarIcon: #imageLiteral(resourceName: "tabbarOtherIcon"))

        profileNavController.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "authBackIndicator").withRenderingMode(.alwaysOriginal)
        profileNavController.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "authBackIndicator").withRenderingMode(.alwaysOriginal)
        profileNavController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        profileNavController.navigationBar.shadowImage = UIImage()
        profileNavController.navigationBar.isTranslucent = true
        profileNavController.view.backgroundColor = .clear
        
        tabBarController.setViewControllers([searchNavController, placesNavController, profileNavController, otherNavController], animated: false)
        
        tabBarController.tabBar.bounds = CGRect(x: 0, y: 0, width: tabBarController.tabBar.bounds.width, height: 60)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard viewController == tabBarController.selectedViewController else { return true }
        guard let profileNavigation = viewController as? ProfileNavigationController else { return true }
        return !(profileNavigation.topViewController is ProfileViewController)
    }
}

class TabbarController: UITabBarController {
    
    var customHeight: CGFloat?
    
    override func viewDidLayoutSubviews() {
        guard let customHeight = customHeight else { return }
        var tabFrame = tabBar.frame
        tabFrame.size.height = customHeight + safeAreaBottomInset
        tabFrame.origin.y = view.frame.size.height - tabFrame.size.height
        self.tabBar.frame = tabFrame
    }
    
}
