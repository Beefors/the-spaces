//
//  ProfileCoordinator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit.UIViewController

enum ProfileCoordinator {
    case authorization
    case register
    case confirmCode(authModel: UserAuthModel)
    case profile
}

extension ProfileCoordinator: StoryboardCoordinator {
    var storyboardName: String { "Profile" }
    
    var controllerID: String {
        switch self {
        case .authorization: return "Authorization"
        case .register: return "Register"
        case .confirmCode: return "ConfirmCode"
        case .profile: return "Profile"
        }
    }
    
    func prepare(viewController: UIViewController) {
        switch self {
        case .confirmCode(let authModel):
            let vc = viewController as! ConfirmCodeViewController
            vc.behaviorService.viewModel.authModel = authModel
        default: return
        }
    }
    
}
