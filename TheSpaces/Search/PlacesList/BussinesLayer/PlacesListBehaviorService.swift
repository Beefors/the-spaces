//
//  PlacesListVCBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 14.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PlacesListBehaviorService: NSObject {
    
    unowned(unsafe) let owner: PlacesListViewController
    unowned(unsafe) let dataViewModel: PlacesViewModel
    let tableViewService: PlacesListTableViewService
    
    init(owner: PlacesListViewController, placesDataProvider: PlacesViewModel) {
        self.owner = owner
        dataViewModel = placesDataProvider
        tableViewService = .init(owner: owner, viewModel: dataViewModel)
    }
    
    func setup() {
        tableViewService.setup()
    }
    
}
