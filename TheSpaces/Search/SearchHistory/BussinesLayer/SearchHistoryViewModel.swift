//
//  SearchHistoryViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MagicalRecord

class SearchHistoryViewModel: ViewModelType {
    let bag = DisposeBag()
    
    let searchTrigger = PublishRelay<String>()
    let searchData = BehaviorRelay<Array<PlaceModel>>(value: [])
    
    let historyDataTrigger = PublishRelay<Void>()
    let historyData = BehaviorRelay<Array<SearchHistoryItem>>(value: [])
    
    let addHistoryItemTrigger = PublishRelay<String>()
    let errorResponse = PublishRelay<Error>()
    
    init() {
        
        historyDataTrigger
            .map({ SearchHistoryItem.mr_findAllSorted(by: "searchedDate", ascending: true) as? [SearchHistoryItem] })
            .filterNil()
            .bind(to: historyData)
            .disposed(by: bag)

        addHistoryItemTrigger
            .do(onNext: { (title) in
                MagicalRecord.save(blockAndWait: { (context) in
                    let item = SearchHistoryItem.mr_createEntity(in: context)
                    item?.title = title
                    item?.searchedDate = Date()
                })
            })
            .map({ _ in return })
            .bind(to: historyDataTrigger)
            .disposed(by: bag)

        // Search by name logic
        setupSearchDataObservable()
    }
    
    func setupSearchDataObservable() {
        searchTrigger
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap { (name) in
                NetworkService.shared.placesList(cityId: 1, filters: [.nameFilter(name: name)])
            }
            .subscribe(onNext: {[unowned self] places in
                self.searchData.accept(places)
            }, onError: {[unowned self] (error) in
                self.errorResponse.accept(error)
                self.searchData.accept([])
                self.setupSearchDataObservable()
            })
            .disposed(by: bag)
    }
    
}
