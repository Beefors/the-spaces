//
//  FilterCellModelType.swift
//  TheSpaces
//
//  Created by Денис Швыров on 31.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit.UITableViewCell

protocol TableCellModelType: ViewModelType {
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func setupCell(_ cell: UITableViewCell)
    
    func cellWillApear(_ cell: UITableViewCell)
    func cellDidApear(_ cell: UITableViewCell)
    
    func cellDidSelect(_ cell: UITableViewCell)
    func cellDidDeselect(_ cell: UITableViewCell)
    
}

extension TableCellModelType {
    func cellWillApear(_ cell: UITableViewCell) {}
    func cellDidApear(_ cell: UITableViewCell) {}
    
    func cellDidSelect(_ cell: UITableViewCell) {}
    func cellDidDeselect(_ cell: UITableViewCell) {}
}
