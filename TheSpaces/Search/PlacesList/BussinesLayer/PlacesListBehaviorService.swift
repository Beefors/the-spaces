//
//  PlacesListVCBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 14.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PlacesListBehaviorService: NSObject {
    
    unowned(unsafe) let owner: PlacesListViewController
    unowned(unsafe) let dataViewModel: PlacesViewModel
    let tableViewService: PlacesListTableViewService
    
    init(owner: PlacesListViewController, placesDataProvider: PlacesViewModel) {
        self.owner = owner
        dataViewModel = placesDataProvider
        tableViewService = .init(owner: owner, viewModel: dataViewModel)
    }
    
    func setup() {
        
        tableViewService.setup()
        
//        Observable.just(self)
//            .flatMap { (behaviorService) in
//                return behaviorService.owner.dismissButton.rx.tap.map({ behaviorService })
//            }
//            .bind { (behaviorService) in
//                guard let searchViewController = behaviorService.owner.parent as? MapViewController else { return }
//                
//                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {[unowned behaviorService, unowned searchViewController] in
//                    behaviorService.owner.view.frame.origin = CGPoint(x: .zero, y: searchViewController.view.bounds.height)
//                }, completion: {[unowned behaviorService] _ in
//                    behaviorService.owner.view.removeFromSuperview()
//                    behaviorService.owner.removeFromParent()
//                })
//                
//            }
//            .disposed(by: dataViewModel)
        
    }
    
}
