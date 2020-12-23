//
//  SearchViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 12.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlacesViewModel: ViewModelType {
    let bag = DisposeBag()
    
    let getPlacesTrigger = PublishRelay<Void>()
    let placesObservable = BehaviorRelay<Array<PlaceModel>>(value: [])

    let filtersPlacesTrigger = BehaviorRelay<Array<PlacesFilter>>(value: [])
    let filteredPlacesObservable = BehaviorRelay<Array<PlaceModel>?>(value: [])
    
    let actualPlacesList = BehaviorRelay<Array<PlaceModel>>(value: [])
    
    let errorObservable = PublishRelay<Error>()
    
    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        
        getPlacesTrigger
            .flatMap { _ -> Observable<Array<PlaceModel>> in
                return NetworkService.shared.placesList(cityId: 1)
            }
            .subscribe(onNext: {[unowned self] (places) in
                self.placesObservable.accept(places)
            }, onError: {[unowned self] (error) in
                
                print(error.localizedDescription)
                self.errorObservable.accept(error)
                self.setupObservables()
            })
            .disposed(by: bag)
        
        filtersPlacesTrigger
            .flatMap { filters -> Observable<Array<PlaceModel>?> in
                if filters.isNotEmpty {
                    return NetworkService.shared.placesList(cityId: 1, filters: filters).map { (places) -> Array<PlaceModel>? in
                        return places
                    }
                } else {
                    return Observable.just(nil)
                }
            }
            .subscribe(onNext: {[unowned self] (places) in
                self.filteredPlacesObservable.accept(places)
            }, onError: {[unowned self] (error) in
                self.errorObservable.accept(error)
                self.setupObservables()
            })
            .disposed(by: bag)
        
        Observable<Array<PlaceModel>>.combineLatest(placesObservable.asObservable(), filteredPlacesObservable.asObservable()) { (allPlaces, filtedPlaces) -> Array<PlaceModel> in
            return filtedPlaces ?? allPlaces
        }
        .bind(to: actualPlacesList)
        .disposed(by: bag)
        
    }
}
