//
//  SearchHistoryViewFactory.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class SearchHistoryViewFactory {
    
    static func createHeaderView() -> SearchHistoryHeaderView {
        return SearchHistoryHeaderView()
    }
    
    static func registerCells(tableView: UITableView) {
        tableView.register(SearchHistoryItemCell.self, forCellReuseIdentifier: SearchHistoryItemCell.reuseIdentifier)
    }
    
    static func dequeueSearchHistoryItemCell(tableView: UITableView) -> SearchHistoryItemCell {
        
        let cell: SearchHistoryItemCell
        
        let reuseIdentifier = SearchHistoryItemCell.reuseIdentifier
        if let temp = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? SearchHistoryItemCell {
            cell = temp
        } else {
            cell = SearchHistoryItemCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
        return cell
    }
    
}
