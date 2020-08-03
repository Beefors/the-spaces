//
//  MapPresentationService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

protocol MapPresentationServiceType {
    func present(viewController: UIViewController)
    func present(coordinator: Coordinator)
    var presentedController: UIViewController? { get }
    func dismissPresented()
}

class MapPresentationService: MapPresentationServiceType {
    
    unowned(unsafe) let owner: MapViewController
    
    init(parent mapViewController: MapViewController) {
        owner = mapViewController
    }
    
    private(set) weak var presentedController: UIViewController?
    
    func present(viewController: UIViewController) {
        
        owner.addChild(viewController)
        owner.view.insertSubview(viewController.view, belowSubview: owner.searchPanelView)
        
        viewController.view.frame.size = owner.view.bounds.size
        viewController.view.frame.origin = CGPoint(x: .zero, y: owner.view.bounds.height)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {[unowned viewController] in
            viewController.view.frame.origin = .zero
        }, completion: nil)
    }
    
    func present(coordinator: Coordinator) {
        let vc = coordinator.viewController
        present(viewController: vc)
    }
    
    func dismissPresented() {
        
        guard let presentedController = presentedController else { return }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {[unowned self, unowned presentedController] in
            presentedController.view.frame.origin = CGPoint(x: .zero, y: self.owner.view.bounds.height)
        }, completion: {[unowned presentedController] _ in
            presentedController.view.removeFromSuperview()
            presentedController.removeFromParent()
        })
        
    }
    
}
