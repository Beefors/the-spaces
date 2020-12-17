//
//  ProfileNavControllerBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift

class ProfileNavControllerBehaviorService: NSObject, ServiceType {
    
    //MARK: Owner type
    typealias Owner = ProfileNavigationController
    
    //MARK: - Properties
    unowned(unsafe) let owner: ProfileNavigationController
    
    //MARK: - Services
    let viewModel = UserViewModel()
    
    required init(owner: ProfileNavigationController) {
        self.owner = owner
    }
    
    //MARK: - Helpers
    func setup() {
        
        owner.interactivePopGestureRecognizer?.delegate = self
        
        viewModel
            .userObservable
            .distinctUntilChanged({ ($0 != nil) == ($1 != nil) })
            .retryWhen({[unowned self] _ in self.owner.rx.observe(Array<UIViewController>.self, #keyPath(UINavigationController.viewControllers)).take(1) })
            .debug()
            .subscribe(onNext: {[unowned self] (userData) in
                if userData != nil {
                    self.showProfile(userData: userData!)
                } else {
                    self.showAuth()
                }
            })
            .disposed(by: viewModel)
            
    }
    
    private func showProfile(userData: UserDataModel) {
        guard owner.topViewController != nil, !(owner.topViewController! is ProfileViewController) else { return }
        guard let id = TabBarSource.shared.tabBarController.viewControllers?.firstIndex(of: owner) else { return }
        
        let animation: RouterManager.PresentationType.PushAnimation = TabBarSource.shared.tabBarController.selectedViewController is ProfileNavigationController ? .standart : .none
        let presentationType = RouterManager.PresentationType.push(by: .onTab(id: id), animated: animation)
        
        guard let profileVC = RouterManager.shared.present(ProfileCoordinator.profile, presentationType: presentationType) else { return }
        owner.setViewControllers([owner.viewControllers[0], profileVC], animated: false)
    }
    
    private func showAuth() {
        owner.popToRootViewController(animated: true)
    }
    
}

extension ProfileNavControllerBehaviorService: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (owner.topViewController as? ProfileViewController) == nil
    }
}
