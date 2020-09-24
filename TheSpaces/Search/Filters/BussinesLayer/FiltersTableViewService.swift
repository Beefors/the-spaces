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
import RxSwiftExt
import RxAppState

class FiltersTableViewService: NSObject, ServiceType {
    typealias Owner = FiltersViewController
    typealias Row = TableCellModelType
    typealias Section = RxSectionModel<TableCellModelType>
    
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
//        tableView.contentInset.bottom = 24
        setupObservables()
    }
    
    private func setupObservables() {
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: owner.behaviorService.viewModel)
        
        let rxDataSource = RxTableViewSectionedReloadDataSource<RxSectionModel<TableCellModelType>>(configureCell: { (dataSource, tableView, indexPath, cellModel) -> UITableViewCell in
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
        let selectedObser: BehaviorRelay<FiltersViewModel.PriceRangeType>
        
        switch priceType {
        case .day:
            
            observable = self.owner
                .behaviorService
                .viewModel
                .dayPriceObservable
                .asObservable()
            
            selectedObser = self.owner
                .behaviorService
                .viewModel
                .selectedDayPriceObservable
            
        case .month:
            
            observable = self.owner
                .behaviorService
                .viewModel
                .monthPriceObservable
                .asObservable()
            
            selectedObser = self.owner
                .behaviorService
                .viewModel
                .selectedMonthPriceObservable
            
        }
        
        if let choosedFilter = owner.behaviorService.viewModel.selectedFiltersObservable.value[priceType.wrapper]?.value as? Dictionary<String, Int> {
            
            let minValue = CGFloat(choosedFilter["min"]!)
            let maxValue = CGFloat(choosedFilter["max"]!)
            
            cellModel.selectedRangeObservable.accept((minValue, maxValue))
        }
        
        observable
            .bind(to: cellModel.rangeValueObservable)
            .disposed(by: cellModel.bag)
        
        cellModel
            .selectedRangeObservable
            .bind(to: selectedObser)
            .disposed(by: cellModel.bag)
        
        owner
            .behaviorService
            .resetTrigger
            .bind(to: cellModel.resetTrigger)
            .disposed(by: cellModel.bag)
        
        return cellModel
    }
    
    private func createSpecificationCellModel(specificationType: FiltersDataSource.Sections.SpecificationsTypes) -> FilterCellSpecificationModel {
        let cellModel = FilterCellSpecificationModel(specificationType: specificationType)
        
        owner
            .behaviorService
            .resetTrigger
            .bind(to: cellModel.resetTrigger)
            .disposed(by: cellModel.bag)
        
        if let filter = owner.behaviorService.viewModel.selectedFiltersObservable.value[specificationType.wrapper], let id = filter.value as? Int {
            
            switch specificationType {
            case .working(let types):
                let type = types.first(where: {$0.rawValue == id})!
                cellModel.selectedFilterObservable.accept(type)
            case .roominess(let types):
                let type = types.first(where: {$0.rawValue == id})!
                cellModel.selectedFilterObservable.accept(type)
            }
            
        }
        
        cellModel.rowDidSelectObservable
            .map { (spetifications) -> (String, [TitlePresentable]) in
                
                let items: [TitlePresentable]
                
                switch spetifications {
                case .roominess(let types): items = types
                case .working(let types): items = types
                }
                
                return (spetifications.title, items)
            }
            .map({(title, items) -> FiltersRadioButtonViewController in
                return SearchCoordinator.filtersRadioButtons(title: title, items: items).viewController as! FiltersRadioButtonViewController
            })
            .do(onNext: {[unowned self, unowned cellModel] (vc) in
                vc.beheviorService.viewModel.appliedFilterObservable.accept(cellModel.selectedFilterObservable.value)
                self.owner.navigationController?.pushViewController(vc, animated: true)
            })
            .flatMap({ (vc) in
                return vc.beheviorService.viewModel.appliedFilterObservable.skip(1)
            })
            .bind(to: cellModel.selectedFilterObservable)
            .disposed(by: owner.behaviorService.viewModel)
        
        cellModel
            .selectedFilterObservable
            .map { (presentable) -> (FilterCheckmarkTypeWrapper, Any?) in
                
                let wrapper = specificationType.wrapper
                var value: Any?
                
                if let presentable = presentable {
                    
                    switch specificationType {
                        
                    case .working(types: let types):
                        
                        for type in types {
                            guard type.title == presentable.title else { continue }
                            value = type.rawValue
                        }
                        
                    case .roominess(types: let types):
                        
                        for type in types {
                            guard type.title == presentable.title else { continue }
                            value = type.rawValue
                        }
                        
                    }
                    
                } else  {
                    value = nil
                }
                
                return (wrapper, value)
            }
            .map {[unowned self] (wrapper, value) -> Dictionary<FilterCheckmarkTypeWrapper, PlacesFilter> in
                var dict = self.owner.behaviorService.viewModel.selectedFiltersObservable.value
                dict[wrapper] = value != nil ? PlacesFilter(key: wrapper.filterKey, value: value!) : nil
                return dict
            }
            .bind(to: owner.behaviorService.viewModel.selectedFiltersObservable)
            .disposed(by: owner.behaviorService.viewModel)
        
        return cellModel
    }
    
    private func createCheckmarkCellModel<Filter: FilterCheckmarkType>(types: [Filter]) -> FilterCellCheckmarksModel<Filter> {
        let model = FilterCellCheckmarksModel<Filter>(flags: types, selectedFlags: [])
        
        for type in types {
            if owner.behaviorService.viewModel.selectedFiltersObservable.value[type.wrapper] != nil {
                var set = model.selectedFiltersObservable.value
                set.insert(type)
                model.selectedFiltersObservable.accept(set)
            }
        }
        
         model.selectedFiltersObservable
            .pairwise()
            .map({[unowned self] (prevVal, nextVal) -> Dictionary<FilterCheckmarkTypeWrapper, PlacesFilter> in
                var filtersDict = self.owner.behaviorService.viewModel.selectedFiltersObservable.value
                
                let removedFilters = prevVal.subtracting(nextVal)
                let apendFilters = nextVal.subtracting(prevVal)
                
                for filter in removedFilters {
                    filtersDict[filter.wrapper] = nil
                }
                
                for filter in apendFilters {
                    let value = PlacesFilter(key: filter.filterKey, value: true)
                    filtersDict[filter.wrapper] = value
                }
                
                return filtersDict
            })
            .bind(to: owner.behaviorService.viewModel.selectedFiltersObservable)
            .disposed(by: owner.behaviorService.viewModel)
        
        owner
            .behaviorService
            .resetTrigger
            .bind(to: model.resetTrigger)
            .disposed(by: model.bag)
        
        model
            .contentSizeUpdatedObservable
            .debounce(.milliseconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (_) in
                self.tableView.reloadData()
            })
            .disposed(by: owner.behaviorService.viewModel)
        
        return model
    }
}

extension FiltersTableViewService: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = FiltersDataSource().sections[section]

        if let title = section.title {
            
            let view = UIView()
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            label.font = .filterParam
            label.textColor = .STBlue
            label.text = title
            
            return view
        } else {
            return nil
        }

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = FiltersDataSource().sections[section]
        return section.title != nil ? 33 : 0
    }
    
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
        
        let sectionModel = self.dataSource[indexPath.section]
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
