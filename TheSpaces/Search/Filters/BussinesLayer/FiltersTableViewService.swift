//
//  FiltersTableViewService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 27.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class FiltersTableViewService: NSObject, ServiceType {
    typealias Owner = FiltersViewController
    
    //MARK: Owner
    unowned(unsafe) let owner: FiltersViewController
    unowned(unsafe) let tableView: UITableView
    
    //MARK: - Properties
    let dataSource = FiltersDataSource().sections
    
    required init(owner: FiltersViewController) {
        self.owner = owner
        tableView  = owner.tableView
    }
    
    func setup() {
        
    }
    
}

extension FiltersTableViewService: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { dataSource.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dataSource[section].rowsCount }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
}
