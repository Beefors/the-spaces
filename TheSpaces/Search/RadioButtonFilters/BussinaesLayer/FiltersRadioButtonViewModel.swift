//
//  FiltersRadioButtonViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FiltersRadioButtonViewModel: ViewModelType {
    let bag = DisposeBag()
    
    var title = String()
    var items = [TitlePresentable]()
    
    let appliedFilterObservable = BehaviorRelay<TitlePresentable?>(value: nil)
    let selectedFilterObservable = BehaviorRelay<TitlePresentable?>(value: nil)
    
}
