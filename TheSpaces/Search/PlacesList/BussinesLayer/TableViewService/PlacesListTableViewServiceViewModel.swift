//
//  PlacesListTableViewServiceViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 15.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlacesListTableViewServiceViewModel: ViewModelType {
    let bag = DisposeBag()
    
    unowned(unsafe) let searchViewMode: MapViewModel
    
    init(searchViewModel: MapViewModel) {
        self.searchViewMode = searchViewModel
    }
    
}
