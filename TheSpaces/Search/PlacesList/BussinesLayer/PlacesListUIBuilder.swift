//
//  PlacesListUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 14.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class PlacesListUIBuilder: NSObject {
    
    let tableViewTopInset: CGFloat
    unowned(unsafe) let owner: PlacesListViewController
    
    private let cellIdentifier = String(describing: type(of: PlaceListCell.self))
    
    init(owner: PlacesListViewController, tableViewTopInset: CGFloat) {
        self.tableViewTopInset = tableViewTopInset
        self.owner = owner
    }
    
    func setup() {
        
        owner.containerBottomConstr.constant = TabBarSource.shared.tabBarController.tabBar.bounds.height
        
        owner.dismissButton.setTitle("На карте", for: .normal)
        
        owner.dismissButton.backgroundColor = .white
        owner.dismissButton.layer.cornerRadius = owner.dismissButton.bounds.height / 2
        owner.dismissButton.layer.borderColor = UIColor.STGray.cgColor
        owner.dismissButton.titleLabel?.font = .priceButton
        owner.dismissButton.setTitleColor(.STGraphite, for: .normal)
        
        owner.tableView.backgroundColor = .blue
        
        let cellNib = UINib(nibName: cellIdentifier, bundle: Bundle.main)
        owner.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
    }
    
}
