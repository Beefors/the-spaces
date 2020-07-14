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

class PlacesListVCBehaviorService: NSObject {
    
    unowned(unsafe) let owner: PlacesListViewController
    unowned(unsafe) let dataViewModel: SearchViewModel
    let tableViewService: PlacesListTableViewService
    
    init(owner: PlacesListViewController, placesDataProvider: SearchViewModel) {
        self.owner = owner
        dataViewModel = placesDataProvider
        tableViewService = .init(tableView: owner.tableView, viewModel: dataViewModel)
    }
    
    func setup() {
        
        owner.dismissButton.rx
            .tap
            .subscribe(onNext: {[unowned self] _ in
                
                guard let presentingNavVC = self.owner.presentingViewController as? UINavigationController else { return }
                guard let searchVC = presentingNavVC.viewControllers.first as? SearchViewController else { return }
                self.owner.searchPanelView.transite(to: TabBarSource.shared.tabBarController.view)
                
                self.owner.dismiss(animated: true) {[unowned self, unowned searchVC] in
                    self.owner.searchPanelView.transite(to: searchVC.view)
                }
            })
            .disposed(by: dataViewModel)
        
    }
    
}
