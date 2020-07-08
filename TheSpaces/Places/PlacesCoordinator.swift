//
//  PlacesCoordinator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit.UIViewController

enum PlacesCoordinator {
    case placesList
}

extension PlacesCoordinator: StoryboardCoordinator {
    var storyboardName: String { "Places" }
    
    var controllerID: String {
        switch self {
        case .placesList: return "PlacesList"
        }
    }
    
    func prepare(viewController: UIViewController) {
        
    }
    
}
