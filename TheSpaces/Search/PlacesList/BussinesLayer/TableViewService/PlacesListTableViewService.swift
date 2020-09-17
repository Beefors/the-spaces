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
    
    required init(owner: PlacesListViewController, viewModel: PlacesViewModel) {
        self.owner = owner
        self.viewModel = PlacesListTableViewServiceViewModel(searchViewModel: viewModel)
        super.init()
    }
    
    func setup() {
        tableView = owner.tableView
        setupObservables()        
    }
    
    private func setupObservables() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<RxSectionModel<PlaceModel>>(configureCell: { (dataSource, tableView, indexPath, place) -> UITableViewCell in
            let cell = PlacesListViewsFactory().dequeuePlaceListCell(tableView)
            cell.placeView.behaviorService.setupData(place)
            
            if dataSource.sectionModels[indexPath.section].items.count - 1 == indexPath.row {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
            } else {
                cell.separatorInset = .zero
            }
            
            return cell
        })
        
        viewModel.searchViewMode
            .actualPlacesList
            .map({ [RxSectionModel(items: $0)] })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel)
        
        Observable.just(tableView!)
            .flatMap { (tableView) -> Observable<(UITableView, IndexPath)> in
                return tableView.rx.itemSelected.map({(tableView, $0)})
            }
            .bind { (tableView, indexPath) in
                tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: viewModel)
        
    }
    
}
