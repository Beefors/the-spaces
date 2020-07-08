//
//  OtherCoordinator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit.UIViewController

enum OtherCoordinator {
    case other
}

extension OtherCoordinator: StoryboardCoordinator {
    var storyboardName: String { "Other" }
    
    var controllerID: String {
        switch self {
        case .other: return "Other"
        }
    }
    
    func prepare(viewController: UIViewController) {
        
    }
    
}
