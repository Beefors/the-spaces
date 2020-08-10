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

class SearchHistoryTableViewService {
    typealias SearchHistorySection = RxSectionModel<SearchHistoryItem>
    
    //MARK: Owner
    unowned(unsafe) let owner: SearchHistoryViewController
    
    //MARK: - Views
    let headerView = SearchHistoryViewFactory.createHeaderView()
    
    //MARK: - Initialization
    init(owner: SearchHistoryViewController) {
        self.owner = owner
    }
    
    //MARK: - Setup
    func setup() {
//        owner.tableView.tableHeaderView = headerView
        
        let dataSource = RxTableViewSectionedReloadDataSource<SearchHistorySection>(configureCell: {(dataSource, tableView, indexPath, item) in
            let cell = SearchHistoryViewFactory.dequeueSearchHistoryItemCell(tableView: tableView)
            cell.textLabel?.text = item.title
            return cell
        })
        
        owner.behaviorService.viewModel
            .historyData
            .map({[SearchHistorySection(items: $0)]})
            .bind(to: owner.tableView.rx.items(dataSource: dataSource))
            .disposed(by: owner.behaviorService.viewModel)
            
        
    }
    
}

