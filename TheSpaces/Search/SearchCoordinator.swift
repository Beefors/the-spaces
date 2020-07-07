//
//  SearchCoordinator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit.UIViewController

enum SearchCoordinator {
    case main
}

extension SearchCoordinator: StoryboardCoordinator {
    var storyboardName: String { "Search" }
    
    var controllerID: String {
        switch self {
        case .main: return "Main"
        }
    }
    
    func prepare(viewController: UIViewController) {
        
    }
    
}
