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
//    let showRadioButtonsScreenTrigger = PublishRelay<(title: String, items: [TitlePresentable])>()
    
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
        
        // Setup clear filters observable
        owner.resetFiltersButton.rx
            .tap
            .map({Dictionary<FilterCheckmarkTypeWrapper, PlacesFilter>()})
            .bind(to: viewModel.selectedFiltersObservable)
            .disposed(by: viewModel)
        
        guard let mapViewModel = viewModel.mapViewModel else { return }
        
        let countObservable = PublishRelay<Int>()
        
        countObservable
            .subscribe(onNext: {[unowned self] (count) in
                self.builderUI.setupPlacesCount(count)
            })
            .disposed(by: viewModel)
        
        mapViewModel
            .placesObservable
            .map({$0.count})
            .bind(to: countObservable)
            .disposed(by: viewModel)
        
        viewModel
            .placesCountByFiltersObservable
            .bind(to: countObservable)
            .disposed(by: viewModel)
        
        owner.applyFiltersButton.rx
            .tap
            .do(onNext: {[unowned self] in
                self.owner.dismiss(animated: true, completion: nil)
            })
            .flatMap {[unowned self] in
                return self.viewModel.selectedFiltersObservable
            }
            .map({ Array($0.values) })
            .bind(to: mapViewModel.filtersPlacesTrigger)
            .disposed(by: viewModel)
        
    }
    
}
