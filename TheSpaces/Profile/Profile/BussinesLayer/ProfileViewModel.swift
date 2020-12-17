//
//  ProfileViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType {
    let bag = DisposeBag()
    
    enum State: Equatable {
        case normal
        case editing
        
        mutating func togle() {
            self = togled()
        }
        
        func togled() -> State {
            self == .normal ? .editing : .normal
        }
        
    }
    
    let stateObservable = BehaviorRelay<State>(value: .normal)
    let togleStateTrigger = PublishRelay<Void>()
    
    init() {
        togleStateTrigger
            .flatMap({[unowned self] in self.stateObservable.take(1)})
            .map({$0.togled()})
            .bind(to: stateObservable)
            .disposed(by: bag)
    }
    
}
