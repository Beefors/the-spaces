//
//  Coordinator.swift
//  stayintouch
//
//  Created by Денис Швыров on 04.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var viewController: UIViewController { get }
}

protocol StoryboardCoordinator: Coordinator {
    var storyboardName: String { get }
    var controllerID: String { get }
    func prepare(viewController: UIViewController)
}

extension StoryboardCoordinator {
    var viewController: UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: controllerID)
        prepare(viewController: controller)
        return controller
    }
}
