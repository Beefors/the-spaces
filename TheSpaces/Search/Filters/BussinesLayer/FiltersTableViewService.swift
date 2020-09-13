//
//  FiltersTableViewService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 27.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FiltersTableViewService: NSObject, ServiceType {
    typealias Owner = FiltersViewController
    typealias Row = FilterCellModelType
    typealias Section = RxSectionModel<FilterCellModelType>
    
    //MARK: Owner
    unowned(unsafe) let owner: FiltersViewController
    unowned(unsafe) let tableView: UITableView
    
    //MARK: - Properties
    private var dataSource = [Section]()
    
    //MARK: - Initialization
    required init(owner: FiltersViewController) {
        self.owner = owner
        tableView  = owner.tableView
        super.init()
        
        var sections = [Section]()
        for sectionType in FiltersDataSource().sections {
            
            var rows = [Row]()
            
            switch sectionType {
            case .prices(let types):
                
                for priceType in types {
                    let cellModel = createPriceCellModel(priceType: priceType)
                    rows.append(cellModel)
                }
                
                
            case .specifications(let types):
                
                for specification in types {
                    let cellModel = createSpecificationCellModel(specificationType: specification)
                    rows.append(cellModel)
                }
                
            case .services(let types):
                rows = [createCheckmarkCellModel(types: types)]
                
            case .equipment(let types):
                rows = [createCheckmarkCellModel(types: types)]
                
            case .facilities(let types):
                rows = [createCheckmarkCellModel(types: types)]
                
            case .transport(let types):
                rows = [createCheckmarkCellModel(types: types)]
                
            }
            
            sections.append(Section(items: rows))
        }
        
        dataSource = sections
    }
    
    //MARK: - Setups
    func setup() {
        tableView.contentInset.bottom = 24
        setupObservables()
    }
    
    private func setupObservables() {
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: owner.behaviorService.viewModel)
        
        let rxDataSource = RxTableViewSectionedReloadDataSource<RxSectionModel<FilterCellModelType>>(configureCell: { (dataSource, tableView, indexPath, cellModel) -> UITableViewCell in
            let cell = cellModel.dequeuCell(tableView: tableView, indexPath: indexPath)
            cellModel.setupCell(cell)
            return cell
        })
        
        Observable<Array<Section>>.just(dataSource)
            .bind(to: tableView.rx.items(dataSource: rxDataSource))
            .disposed(by: owner.behaviorService.viewModel)
        
        DispatchQueue.main.async {
            self.owner.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    private func createPriceCellModel(priceType: FiltersDataSource.Sections.PricesTypes) -> FilterCellPriceModel {
        
        let cellModel = FilterCellPriceModel(priceType: priceType)
        let observable: Observable<FiltersViewModel.PriceRangeType>
        
        switch priceType {
        case .day:
            
            observable = self.owner
                .behaviorService
                .viewModel
                .dayPriceObservable
                .asObservable()
            
        case .month:
            
            observable = self.owner
                .behaviorService
                .viewModel
                .monthPriceObservable
                .asObservable()
            
        }
        
        observable
            .bind(to: cellModel.rangeValueObservable)
            .disposed(by: owner.behaviorService.viewModel)
        
        return cellModel
    }
    
    private func createSpecificationCellModel(specificationType: FiltersDataSource.Sections.SpecificationsTypes) -> FilterCellSpecificationModel {
        let cellModel = FilterCellSpecificationModel(specificationType: specificationType)
        return cellModel
    }
    
    private func createCheckmarkCellModel<Filter: FilterCheckmarkType>(types: [Filter]) -> FilterCellCheckmarksModel<Filter> {
        
        let model = FilterCellCheckmarksModel<Filter>(flags: types, selectedFlags: [])
        
        model
            .contentSizeUpdatedObservable
            .subscribe(onNext: {[unowned self] (cell) in
                guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                self.tableView.rectForRow(at: indexPath)
            })
            .disposed(by: owner.behaviorService.viewModel)
        
        return model
    }
}

extension FiltersTableViewService: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .STGray
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let sectionType = FiltersDataSource().sections[section]
        
        switch sectionType {
        case .transport: return 0
        default: return 0.5
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let sectionModel = dataSource[indexPath.section]
        let rowModel = sectionModel.items[indexPath.row]
        
        rowModel.cellWillApear(cell)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let sectionModel = dataSource[indexPath.section]
        let rowModel = sectionModel.items[indexPath.row]
        
        rowModel.cellDidApear(cell)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        let section = FiltersDataSource().sections[indexPath.section]
        
        switch section {
        case .specifications: return true
        default: return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let sectionModel = dataSource[indexPath.section]
        let rowModel = sectionModel.items[indexPath.row]
        
        rowModel.cellDidSelect(cell)
    }
    
}
