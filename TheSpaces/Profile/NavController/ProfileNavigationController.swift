//
//  ProfileNavigationController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    
    lazy var behaviorService = ProfileNavControllerBehaviorService(owner: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        behaviorService.setup()
    }
    
}
