//
//  PlacesListTableViewService.swift
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

class PlacesListTableViewService: NSObject {
    
    unowned(unsafe) let owner: PlacesListViewController
    unowned(unsafe) private(set) var tableView: UITableView!
    let viewModel: PlacesListTableViewServiceViewModel
    
    required init(owner: PlacesListViewController, viewModel: SearchViewModel) {
        self.owner = owner
        self.viewModel = PlacesListTableViewServiceViewModel(searchViewModel: viewModel)
        super.init()
    }
    
    func setup() {
        tableView = owner.tableView
        setupObservables()        
    }
    
    private func setupObservables() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<RxSectionModel<PlaceModel>>(configureCell: { (dataSource, tableView, IndexPath, place) -> UITableViewCell in
            let cell = PlacesListViewsFactory().dequeuePlaceListCell(tableView)
            cell.placeView.setupData(place)
            return cell
        })
        
        viewModel.searchViewMode
            .placesObservable
            .map({ [RxSectionModel(items: $0)] })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel)
        
    }
    
}
