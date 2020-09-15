//
//  FilterPriceCellModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 31.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FilterCellPriceModel: FilterCellModelType {
    let bag = DisposeBag()
    let priceType: FiltersDataSource.Sections.PricesTypes
    
    let rangeValueObservable: BehaviorRelay<FiltersViewModel.PriceRangeType>
    let selectedRangeObservable: BehaviorRelay<FiltersViewModel.PriceRangeType>
    
    init(priceType: FiltersDataSource.Sections.PricesTypes, minValue: CGFloat = 0, maxValue: CGFloat = 0, selectedMinValue: CGFloat? = nil, selectedMaxValue: CGFloat? = nil) {
        self.priceType = priceType
        rangeValueObservable = .init(value: (minValue, maxValue))
        selectedRangeObservable = .init(value: (selectedMinValue ?? minValue, selectedMaxValue ?? maxValue))
    }
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return FiltersViewsFactory.dequeuPriceCell(for: tableView)
    }
    
    private var rangeDisposable: Disposable?
    private var selectedRangeDisposable: Disposable?
    
    func setupCell(_ cell: UITableViewCell) {
        guard let cell = cell as? FilterRangeSliderCell else { return }
        cell.label.text = priceType.title
        
        rangeDisposable?.dispose()
        rangeDisposable = rangeValueObservable
            .subscribe(onNext: {[weak cell] (min, max) in
                cell?.set(lowerValue: min, upperValue: max)
            })
        
        selectedRangeDisposable?.dispose()
        selectedRangeDisposable = cell.selectedRangeObservable.bind(to: selectedRangeObservable)
        
    }
    
    func cellDidSelect(_ cell: UITableViewCell) {}
    func cellDidDeselect(_ cell: UITableViewCell) {}
    
}
