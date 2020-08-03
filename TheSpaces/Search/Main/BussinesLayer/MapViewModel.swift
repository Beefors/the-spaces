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

class MapViewModel: ViewModelType {
    let bag = DisposeBag()
    
    let getPlacesTrigger = PublishRelay<Void>()
    let placesObservable = BehaviorRelay<Array<PlaceModel>>(value: [])
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
                self.errorObservable.accept(error)
                self.setupObservables()
            })
            .disposed(by: bag)
        
    }
}
