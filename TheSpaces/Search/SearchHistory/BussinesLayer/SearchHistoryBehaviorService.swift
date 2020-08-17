//
//  SearchHistoryBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchHistoryBehaviorService {
    
    //MARK: Owner
    unowned(unsafe) let owner: SearchHistoryViewController
    
    //MARK: - Services
    lazy var tableViewService = SearchHistoryTableViewService(owner: owner)
    lazy var builderUI = SearchHistoryUIBuilder(owner: owner)
    
    //MARK: - View model
    let viewModel = SearchHistoryViewModel()
    
    //MARK: - Initialization
    init(owner: SearchHistoryViewController) {
        self.owner = owner
    }
    
    //MARK: - Setup
    func setup() {
        builderUI.buildUI()
        tableViewService.setup()
        
        setupObservables()
    }
    
    private func setupObservables() {
        
        let skipCount = (builderUI.searchPanel.textField.text?.count ?? 0) > 0 ? 0 : 1
        
        builderUI.searchPanel
            .textField.rx
            .text
            .skip(skipCount)
            .filterNil()
            .filterEmpty()
            .bind(to: viewModel.searchTrigger)
            .disposed(by: viewModel)
        
        builderUI.searchPanel
            .textField.rx
            .text
            .skip(skipCount)
            .filterNil()
            .filter({$0.isEmpty}) // If string is empty, 
            .map({_ in return Array<PlaceModel>()})
            .bind(to: viewModel.searchData)
            .disposed(by: viewModel)
        
        viewModel
            .searchData
            .subscribe()
            .disposed(by: viewModel)
        
    }
    
}
