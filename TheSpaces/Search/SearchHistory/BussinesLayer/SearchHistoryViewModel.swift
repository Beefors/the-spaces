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
    
    let historyDataTrigger = PublishRelay<Void>()
    let historyData = BehaviorRelay<Array<SearchHistoryItem>>(value: [])
    
    let addHistoryItemTrigger = PublishRelay<String>()
    
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
        
    }
    
}
