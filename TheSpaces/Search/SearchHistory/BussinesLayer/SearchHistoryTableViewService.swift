//
//  SearchHistoryTableViewService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchHistoryTableViewService: NSObject {
    typealias SearchHistorySection = RxSectionModel<SearchHistoryItem>
    
    //MARK: Owner
    unowned(unsafe) let owner: SearchHistoryViewController
    unowned(unsafe) let tableView: UITableView
    
    //MARK: - Views
    let historyHeaderView = SearchHistoryViewFactory.createHistorySectionHeaderView()
    
    //MARK: - Initialization
    init(owner: SearchHistoryViewController) {
        self.owner = owner
        tableView = owner.tableView
    }
    
    //MARK: - Setup
    func setup() {
        
        SearchHistoryViewFactory.registerCells(tableView: owner.tableView)
        
        tableView.rx
            .setDataSource(self)
            .disposed(by: owner.behaviorService.viewModel)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: owner.behaviorService.viewModel)
        
        owner.behaviorService.viewModel
            .searchData
            .distinctUntilChanged()
            .subscribe(onNext: {[unowned self] _ in
                self.tableView.reloadData()
            })
            .disposed(by: owner.behaviorService.viewModel)
        
    }
    
}

extension SearchHistoryTableViewService: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return owner.behaviorService.viewModel.searchData.value.count
        case 1: return owner.behaviorService.viewModel.historyData.value.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = SearchHistoryViewFactory.dequeueSearchResultCell(tableView: tableView)
            let place = owner.behaviorService.viewModel.searchData.value[indexPath.row]
            cell.label.text = place.name
            cell.setupLabelLeadingOffset(7.5)
            
            return cell
        case 1:
            
            let cell = SearchHistoryViewFactory.dequeueSearchHistoryItemCell(tableView: tableView)
            let item = owner.behaviorService.viewModel.historyData.value[indexPath.row]
            cell.textLabel?.text = item.title
            
            return cell
        default: abort()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0: return owner.behaviorService.viewModel.searchData.value.count == 0 ? 0 : 24
        case 1: return owner.behaviorService.viewModel.historyData.value.count == 0 ? 0 : 40
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: return SearchHistoryViewFactory.createSearchSectionHeaderView(leadingOffset: 7.5)
        case 1: return historyHeaderView
        default: return nil
        }
    }
    
}
