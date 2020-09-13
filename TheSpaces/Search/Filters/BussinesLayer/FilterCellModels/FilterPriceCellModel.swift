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
    
    let selectedMinValueObservable: BehaviorRelay<CGFloat>
    let selectedMaxValueObservable: BehaviorRelay<CGFloat>
    
    init(priceType: FiltersDataSource.Sections.PricesTypes, minValue: CGFloat = 0, maxValue: CGFloat = 0, selectedMinValue: CGFloat? = nil, selectedMaxValue: CGFloat? = nil) {
        self.priceType = priceType
        rangeValueObservable = .init(value: (minValue, maxValue))
        
        selectedMinValueObservable = .init(value: selectedMinValue ?? minValue)
        selectedMaxValueObservable = .init(value: selectedMaxValue ?? maxValue)
    }
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return FiltersViewsFactory.dequeuPriceCell(for: tableView)
    }
    
    func setupCell(_ cell: UITableViewCell) {
        guard let cell = cell as? FilterRangeSliderCell else { return }
        cell.label.text = priceType.title
        let range = rangeValueObservable.value
        cell.set(lowerValue: range.min, upperValue: range.max)
    }
    
    func cellDidSelect(_ cell: UITableViewCell) {}
    func cellDidDeselect(_ cell: UITableViewCell) {}
    
}
