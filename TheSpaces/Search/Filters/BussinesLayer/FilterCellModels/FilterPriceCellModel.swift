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

class FilterCellPriceModel: TableCellModelType {
    let bag = DisposeBag()
    let priceType: FiltersDataSource.Sections.PricesTypes
    
    let rangeValueObservable: BehaviorRelay<FiltersViewModel.PriceRangeType>
    let selectedRangeObservable: BehaviorRelay<FiltersViewModel.PriceRangeType>
    let resetTrigger = PublishRelay<Void>()
    
    init(priceType: FiltersDataSource.Sections.PricesTypes, minValue: CGFloat = 0, maxValue: CGFloat = 0, selectedMinValue: CGFloat? = nil, selectedMaxValue: CGFloat? = nil) {
        self.priceType = priceType
        rangeValueObservable = .init(value: (minValue, maxValue))
        selectedRangeObservable = .init(value: (selectedMinValue ?? minValue, selectedMaxValue ?? maxValue))
    }
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return FiltersViewsFactory.dequeuPriceCell(for: tableView)
    }
    
    private var setupBag = DisposeBag()
    
    func setupCell(_ cell: UITableViewCell) {
        guard let cell = cell as? FilterRangeSliderCell else { return }
        cell.label.text = priceType.title
        cell.selectedRangeObservable.accept(selectedRangeObservable.value)
        
        setupBag = DisposeBag()
        
        resetTrigger
            .map {[unowned self] _ -> FiltersViewModel.PriceRangeType in
                return self.rangeValueObservable.value
            }
            .subscribe(onNext: {[unowned cell] (value) in
                cell.selectedRangeObservable.accept(value)
                cell.rangeSlider.selectedMinValue = value.min
                cell.rangeSlider.selectedMaxValue = value.max
                cell.rangeSlider.layoutSubviews()
            })
            .disposed(by: setupBag)
        
        Observable.combineLatest(rangeValueObservable.asObservable(), selectedRangeObservable.asObservable())
            .subscribe {[weak cell] (rangeValue, selectedRangeValue) in
                cell?.set(lowerValue: rangeValue.min, upperValue: rangeValue.max)
                cell?.rangeSlider.selectedMinValue = max(rangeValue.min, selectedRangeValue.min)
                
                if selectedRangeValue.max < rangeValue.min {
                    cell?.rangeSlider.selectedMaxValue = rangeValue.max
                } else {
                    cell?.rangeSlider.selectedMaxValue = min(rangeValue.max, max(rangeValue.min, selectedRangeValue.max))
                }
                
                cell?.rangeSlider.layoutSubviews()
            }
            .disposed(by: setupBag)
        
        cell.selectedRangeObservable
            .skip(1)
            .bind(to: selectedRangeObservable)
            .disposed(by: setupBag)
        
        selectedRangeObservable
            .debug()
            .subscribe()
            .disposed(by: setupBag)
        
    }
    
    func cellDidSelect(_ cell: UITableViewCell) {}
    func cellDidDeselect(_ cell: UITableViewCell) {}
    
}
