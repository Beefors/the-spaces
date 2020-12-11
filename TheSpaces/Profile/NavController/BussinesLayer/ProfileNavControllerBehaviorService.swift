//
//  ProfileNavControllerBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

class ProfileNavControllerBehaviorService: ServiceType {
    typealias Owner = ProfileNavigationController
    
    unowned(unsafe) let owner: ProfileNavigationController
    
    let viewModel = UserViewModel()
    
    required init(owner: ProfileNavigationController) {
        self.owner = owner
    }
    
    func setup() {}
}
