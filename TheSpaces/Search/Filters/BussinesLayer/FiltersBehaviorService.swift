//
//  FiltersBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 26.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FilterBehaviorService: ServiceType {
    typealias Owner = FiltersViewController

    //MARK: Owner
    unowned(unsafe) let owner: FiltersViewController
    
    //MARK: - Services
    lazy var builderUI = FiltersUIBuilder(owner: owner)
    lazy var tableViewService = FiltersTableViewService(owner: owner)
    let viewModel = FiltersViewModel()
    
    //MARK: - Initialization
    required init(owner: FiltersViewController) {
        self.owner = owner
    }
    
    //MARK: - Setups
    func setup() {
        builderUI.setup()
        tableViewService.setup()
        setupObservables()
    }
    
    private func setupObservables() {
        
        // Setup dismiss observable
        builderUI.closeItem.rx
            .tap
            .subscribe(onNext: {[unowned self] in
                self.owner.dismiss(animated: true, completion: nil)
            })
            .disposed(by: viewModel)
        
        guard let mapViewModel = viewModel.mapViewModel else { return }
        
        mapViewModel
            .placesObservable
            .map({$0.count})
            .subscribe(onNext: {[unowned self] (count) in
                self.builderUI.setupPlacesCount(count)
            })
            .disposed(by: viewModel)
        
    }
    
}
