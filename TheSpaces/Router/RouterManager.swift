//
//  RouterManager.swift
//  The Spaces
//
//  Created by Денис Швыров on 04.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
//import RxSwift
//import RxCocoa

class RouterManager: NSObject {
    
    //MARK: Shared instance
    static let shared = RouterManager()
    
    //MARK: - Observables
//    let appDidFinishLoading = PublishRelay<Void>()
    
    //MARK: - Variables
    let window: UIWindow
    let tabBarController: UITabBarController
    
    //MARK: - Private varables
    
    //MARK: - Setup
    override init() {
        
        tabBarController = UITabBarController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.rootViewController = tabBarController
        
        super.init()
    }
    
    func setup(forAppDelegate appDelegate: AppDelegate) {
        
        TabBarSource.shared.setupForTabBarController(tabBarController)
        
        appDelegate.window = window
        window.makeKeyAndVisible()
        
    }
    
}

extension RouterManager {
    
    //MARK: - Present type
    enum PresentationType {
        
        enum PushTabBarType {
            case onSelectedTab
            case onTab(id: Int)
        }
        
        case push(by: PushTabBarType, animated: Bool)
    }
    
    @discardableResult // Return nil value when presentation aborted
    func present(_ coordinator: Coordinator, presentationType type: PresentationType = .push(by: .onSelectedTab, animated: true)) -> UIViewController? {
        let vc = coordinator.viewController
        
        switch type {
        case .push(let pushContext, let animated):
            
            switch pushContext {
            case .onSelectedTab:
                
                guard let selectedNavController = tabBarController.selectedViewController as? UINavigationController else { return nil }
                selectedNavController.pushViewController(vc, animated: animated)
                
            case .onTab(let id):
                
                guard let viewControllers = tabBarController.viewControllers, viewControllers.count > id else { return nil }
                guard let navController = viewControllers[id] as? UINavigationController else { return nil }
                
                navController.pushViewController(vc, animated: animated)
            }
        }
        
        return vc
    }
    
    @discardableResult // Return nil value when presentation aborted
    func setupRootController(_ coordinator: Coordinator, forTab type: PresentationType.PushTabBarType, animated: Bool = false) -> UIViewController? {
        let vc = coordinator.viewController
        
        switch type {
        case .onSelectedTab:
            
            guard let navController = tabBarController.selectedViewController as? UINavigationController else { return nil }
            navController.setViewControllers([vc], animated: animated)
            
        case .onTab(let id):
            
            guard let viewControllers = tabBarController.viewControllers, viewControllers.count > id else { return nil }
            guard let navController = viewControllers[id] as? UINavigationController else { return nil }
            navController.setViewControllers([vc], animated: animated)
            
        }
        
        return vc
    }
    
}
