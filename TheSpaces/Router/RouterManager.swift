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
    let tabBarController: TabbarController
    
    //MARK: - Private varables
    
    //MARK: - Setup
    override init() {
        
        tabBarController = TabbarController()
        
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
        
        enum PushAnimation: Equatable {
            case none
            case standart
            case fromBottom
        }
        
        /// Presenting view controller by navigation controller
        case push(by: PushTabBarType, animated: PushAnimation)
        
        typealias Completion = (UIViewController?) -> ()
        /// Use standart present(vc:animated:complition) method of UIViewController. Using UINavigationController of current tab
        case present(animated: Bool, completion: Completion?)
        
    }
    
    @discardableResult // Return nil value when presentation aborted
    func present(_ coordinator: Coordinator, presentationType type: PresentationType = .push(by: .onSelectedTab, animated: .standart)) -> UIViewController? {
        let vc = coordinator.viewController
        
        switch type {
        case .push(let pushContext, let animation):
            
            let navController: UINavigationController
            
            switch pushContext {
            case .onSelectedTab:
                
                guard let selectedNavController = tabBarController.selectedViewController as? UINavigationController else { return nil }
                navController = selectedNavController
                
            case .onTab(let id):
                
                guard let viewControllers = tabBarController.viewControllers, viewControllers.count > id else { return nil }
                guard let neededController = viewControllers[id] as? UINavigationController else { return nil }
                
                navController = neededController
            }
            
            let animated = animation == .standart
            
            switch animation {
            case .fromBottom:
                
                let transition = CATransition()
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
                transition.type = .moveIn
                transition.subtype = .fromTop
                
                navController.view.layer.add(transition, forKey: nil)
                
            default: break
            }
            
            navController.pushViewController(vc, animated: animated)
            
        case .present(let animated, let completion):
            guard let selectedNavController = tabBarController.selectedViewController as? UINavigationController else { return nil }
            selectedNavController.viewControllers.last?.present(vc, animated: animated, completion: { [weak vc] in completion?(vc) })
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
