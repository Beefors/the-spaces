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
    unowned(unsafe) let dataViewModel: SearchViewModel
    let tableViewService: PlacesListTableViewService
    
    init(owner: PlacesListViewController, placesDataProvider: SearchViewModel) {
        self.owner = owner
        dataViewModel = placesDataProvider
        tableViewService = .init(owner: owner, viewModel: dataViewModel)
    }
    
    func setup() {
        
        tableViewService.setup()
        
        Observable.just(self)
            .flatMap { (behaviorService) in
                return behaviorService.owner.dismissButton.rx.tap.map({ behaviorService })
            }
            .bind { (behaviorService) in
                guard let searchViewController = behaviorService.owner.parent as? SearchViewController else { return }
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {[unowned behaviorService, unowned searchViewController] in
                    behaviorService.owner.view.frame.origin = CGPoint(x: .zero, y: searchViewController.view.bounds.height)
                }, completion: {[unowned behaviorService] _ in
                    behaviorService.owner.view.removeFromSuperview()
                    behaviorService.owner.removeFromParent()
                })
                
            }
            .disposed(by: dataViewModel)
        
//        owner.dismissButton.rx
//        .tap
//        .subscribe(onNext: {[unowned self] _ in
//
//            guard let presentingNavVC = self.owner.presentingViewController as? UINavigationController else { return }
//            guard let searchVC = presentingNavVC.viewControllers.first as? SearchViewController else { return }
//            self.owner.searchPanelView.transite(to: TabBarSource.shared.tabBarController.view)
//
//            self.owner.dismiss(animated: true) {[unowned self, unowned searchVC] in
//                self.owner.searchPanelView.transite(to: searchVC.view)
//            }
//        })
//        .disposed(by: dataViewModel)
        
//        Observable.just(self)
//            .flatMap { (behaviorService) in
//                return behaviorService.owner.dismissButton.rx.tap.map({ behaviorService })
//            }
//            .do(onNext: { (behaviorService) in
//                guard let navVC = self.owner.navigationController else { return }
//                navVC.popViewController(animated: false)
//                behaviorService.owner.searchPanelView.transite(to: TabBarSource.shared.tabBarController.view)
//            })
//            .flatMap { (behaviorService) in
//                return behaviorService.owner.rx.viewDidDisappear.map({ _ in behaviorService})
//            }
//            .bind { (behaviorService) in
//                guard let navVC = behaviorService.owner.navigationController else { return }
//                guard let searchVC = navVC.viewControllers.first as? SearchViewController else { return }
//                behaviorService.owner.searchPanelView.transite(to: searchVC.view)
//            }
//            .disposed(by: dataViewModel)
        
    }
    
}
