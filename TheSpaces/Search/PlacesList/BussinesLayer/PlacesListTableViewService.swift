//
//  PlacesListTableViewService.swift
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

class PlacesListTableViewService: NSObject {
    
    unowned(unsafe) let tableView: UITableView
    unowned(unsafe) let viewModel: SearchViewModel
    
    required init(tableView: UITableView, viewModel: SearchViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
    }
    
}
