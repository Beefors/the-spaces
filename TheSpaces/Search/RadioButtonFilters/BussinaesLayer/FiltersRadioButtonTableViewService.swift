//
//  FiltersRadioButtonTableViewService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FiltersRadioButtonTableViewService: ServiceType {
    typealias Owner = FiltersRadioButtonViewController

    unowned(unsafe) let owner: FiltersRadioButtonViewController
    unowned(unsafe) let tableView: UITableView
    
    required init(owner: FiltersRadioButtonViewController) {
        self.owner = owner
        tableView = owner.tableView
    }
    
    func setup() {
        
        let itemsObservable = Observable.just(owner.beheviorService.viewModel.items)
        
        let dataSource = RxTableViewSectionedReloadDataSource<RxSectionModel<TitlePresentable>> (configureCell: {[unowned self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = FiltersRadioButtonViewsFactory.dequeueCell(tableView: tableView)
            cell.checkButton.label.text = item.title
            
            if let selectedFilter = self.owner.beheviorService.viewModel.appliedFilterObservable.value, selectedFilter.title == item.title {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//                cell.checkButton.isSelected = true
            }
            
            return cell
        })
        
        itemsObservable
            .map({[RxSectionModel(items: $0)]})
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: owner.beheviorService.viewModel)
        
        
        
    }
    
}
