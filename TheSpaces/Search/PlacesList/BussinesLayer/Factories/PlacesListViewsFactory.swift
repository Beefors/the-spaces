//
//  PlacesListViewsFactory.swift
//  TheSpaces
//
//  Created by Денис Швыров on 15.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class PlacesListViewsFactory {
    
    private let cellIdentifier = String(describing: PlaceListCell.self)
    
    func registerPlaceListCell(to tableView: UITableView) {
        let cellNib = UINib(nibName: cellIdentifier, bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
    }
    
    func dequeuePlaceListCell(_ tableView: UITableView) -> PlaceListCell {
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PlaceListCell
    }
    
    
}
