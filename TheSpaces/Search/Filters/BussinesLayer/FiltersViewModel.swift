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
        
    }
    
}
