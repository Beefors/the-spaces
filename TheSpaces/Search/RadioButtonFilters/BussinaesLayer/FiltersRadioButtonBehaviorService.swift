//
//  FiltersRadioButtonBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FiltersRadioButtonBehaviorService: ServiceType {
    typealias Owner = FiltersRadioButtonViewController
    
    //MARK: Owner
    unowned(unsafe) let owner: FiltersRadioButtonViewController
    
    //MARK: - Services
    lazy var builderUI = FiltersRadioButtonUIBuilder(owner: owner)
    lazy var tableViewService = FiltersRadioButtonTableViewService(owner: owner)
    let viewModel = FiltersRadioButtonViewModel()
    
    //MARK: - Initialization
    required init(owner: FiltersRadioButtonViewController) {
        self.owner = owner
    }
    
    //MARK: - Setups
    func setup() {
        builderUI.setup()
        tableViewService.setup()
        
        owner.resetButton.rx
            .tap
            .subscribe(onNext: {[unowned self] in
                self.viewModel.selectedFilterObservable.accept(nil)
                self.viewModel.appliedFilterObservable.accept(nil)
                self.owner.tableView.reloadData()
            })
            .disposed(by: viewModel)
        
        owner.applyButton.rx
            .tap
            .subscribe(onNext: {[unowned self] in
                let selected = self.viewModel.selectedFilterObservable.value
                self.viewModel.appliedFilterObservable.accept(selected)
                self.owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: viewModel)
        
        owner.tableView.rx
            .modelSelected(TitlePresentable.self)
            .bind(to: viewModel.selectedFilterObservable)
            .disposed(by: viewModel)
        
    }
    
}
