//
//  FiltersViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 26.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FiltersViewModel: ViewModelType {
    let bag = DisposeBag()
    
    unowned(unsafe) var mapViewModel: PlacesViewModel?
    
    typealias PriceRangeType = (min: CGFloat, max: CGFloat)
    let dayPriceObservable = BehaviorRelay<PriceRangeType>(value: (0, 0))
    let monthPriceObservable = BehaviorRelay<PriceRangeType>(value: (0, 0))
    
    let selectedDayPriceObservable = BehaviorRelay<PriceRangeType>(value: (0, 0))
    let selectedMonthPriceObservable = BehaviorRelay<PriceRangeType>(value: (0, 0))
    
    let selectedFiltersObservable = BehaviorRelay<Dictionary<FilterCheckmarkTypeWrapper, PlacesFilter>>(value: [:])
    let placesCountByFiltersObservable = BehaviorRelay<Int>(value: 0)
    
    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        
        selectedFiltersObservable
            .skip(1)
            .distinctUntilChanged()
            .flatMap({ (dict) in
                return NetworkService.shared.filterPlacesCount(cityId: 1, filters: Array(dict.values))
            })
            .subscribe(onNext: {[weak self] (count) in
                self?.placesCountByFiltersObservable.accept(count)
            }, onError: {[weak self] (error) in
                self?.setupObservables()
            })
            .disposed(by: bag)
    }
    
    func setPlacesViewModel(_ mapViewModel: PlacesViewModel) {
        self.mapViewModel = mapViewModel
        
        // Min day price observable
        let minDayPriceObservable = mapViewModel
            .placesObservable
            .map({ (places) -> Float? in
                places.map { (place) in
                    place.seatType(by: .day)
                }
                .filter({ $0 != nil })
                .map({$0!})
                .map({$0.price})
                .min()
            })
            .replaceNilWith(0)
            .map({CGFloat($0)})
        
        // Max day price observable
        let maxDayPriceObservable = mapViewModel
            .placesObservable
            .map({ (places) -> Float? in
                places.map { (place) in
                    place.seatType(by: .day)
                }
                .filter({ $0 != nil })
                .map({$0!})
                .map({$0.price})
                .max()
            })
            .replaceNilWith(0)
            .map({CGFloat($0)})
        
        Observable<PriceRangeType>.zip(minDayPriceObservable, maxDayPriceObservable, resultSelector: {($0, $1)})
            .bind(to: dayPriceObservable)
            .disposed(by: bag)
        
        // Min month price observable
        let minMonthPriceObservable = mapViewModel
        .placesObservable
        .map({ (places) -> Float? in
            places.map { (place) in
                place.seatType(by: .month)
            }
            .filter({ $0 != nil })
            .map({$0!})
            .map({$0.price})
            .min()
        })
        .replaceNilWith(0)
        .map({CGFloat($0)})
        
        // Max month price observable
        let maxMonthPriceObservable = mapViewModel
            .placesObservable
            .map({ (places) -> Float? in
                places.map { (place) in
                    place.seatType(by: .month)
                }
                .filter({ $0 != nil })
                .map({$0!})
                .map({$0.price})
                .max()
            })
            .replaceNilWith(0)
            .map({CGFloat($0)})
        
        Observable<PriceRangeType>.zip(minMonthPriceObservable, maxMonthPriceObservable, resultSelector: {($0, $1)})
            .bind(to: monthPriceObservable)
            .disposed(by: bag)
        
        dayPriceObservable
            .filter({[unowned self] in
                let selectdValue = self.selectedDayPriceObservable.value
                return $0.min > selectdValue.min || $0.max < selectdValue.max
            })
            .map({[unowned self] in
                let selectdValue = self.selectedDayPriceObservable.value
                let minVal = max($0.min, selectdValue.min)
                let maxVal = min($0.max, selectdValue.max)
                return PriceRangeType(minVal, maxVal)
            })
            .bind(to: selectedDayPriceObservable)
            .disposed(by: bag)
        
        monthPriceObservable
            .filter({[unowned self] in
                let selectdValue = self.selectedMonthPriceObservable.value
                return $0.min > selectdValue.min || $0.max < selectdValue.max
            })
            .map({[unowned self] in
                let selectdValue = self.selectedMonthPriceObservable.value
                let minVal = max($0.min, selectdValue.min)
                let maxVal = min($0.max, selectdValue.max)
                return PriceRangeType(minVal, maxVal)
            })
            .bind(to: selectedMonthPriceObservable)
            .disposed(by: bag)
        
        selectedDayPriceObservable
            .subscribe(onNext: {[unowned self] (value) in
                let dayFilterType = FiltersDataSource.Sections.PricesTypes.day
                let dayWrapper = dayFilterType.wrapper
                let priceRange = self.dayPriceObservable.value
                
                let selectedIsNotEqualNormalRange = value.min == priceRange.min && value.max == priceRange.max
                
                var dict = self.selectedFiltersObservable.value
                
                if selectedIsNotEqualNormalRange {
                    dict[dayWrapper] = dayFilterType.filter(minValue: Int(value.min), maxValue: Int(value.max))
                } else {
                    dict.removeValue(forKey: dayWrapper)
                }
            })
            .disposed(by: bag)
        
        selectedMonthPriceObservable
            .subscribe(onNext: {[unowned self] (value) in
                let monthFilterType = FiltersDataSource.Sections.PricesTypes.month
                let monthWrapper = monthFilterType.wrapper
                let priceRange = self.monthPriceObservable.value
                
                let selectedIsEqualNormalRange = value.min == priceRange.min && value.max == priceRange.max
                
                var dict = self.selectedFiltersObservable.value
                
                if !selectedIsEqualNormalRange {
                    dict[monthWrapper] = monthFilterType.filter(minValue: Int(value.min), maxValue: Int(value.max))
                } else {
                    dict.removeValue(forKey: monthWrapper)
                }
                
                self.selectedFiltersObservable.accept(dict)
            })
            .disposed(by: bag)
        
    }
    
}

struct FilterCheckmarkTypeWrapper: Hashable {
    let filterKey: String
}

extension FilterCheckmarkType {
    var wrapper: FilterCheckmarkTypeWrapper {
        return FilterCheckmarkTypeWrapper(filterKey: filterKey)
    }
    
    init(wrapper: FilterCheckmarkTypeWrapper) {
        self.init(filterKey: wrapper.filterKey)!
    }
    
}
