//
//  AuthBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 21.10.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxKeyboard

class AuthBehaviorService: ServiceType {
    
    //MARK: Owner type
    typealias Owner = AuthorizationViewController

    //MARK: - Properties
    unowned(unsafe) let owner: AuthorizationViewController
    let viewModel = AuthViewModel()
    
    //MARK: - Initialization
    required init(owner: AuthorizationViewController) {
        self.owner = owner
    }
    
    //MARK: - Services
    lazy var builderUI = AuthuiBuilder(owner: owner)
    
    //MARK: - Help methods
    func setup() {
        builderUI.buildUI()
        
        owner
            .registerButton.rx
            .tap
            .map({RouterManager.Route(coordinator: ProfileCoordinator.register)})
            .bind(to: RouterManager.shared.rx.present)
            .disposed(by: viewModel)
        
    }
    
}
