//
//  SearchHistoryBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

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
    }
    
}
