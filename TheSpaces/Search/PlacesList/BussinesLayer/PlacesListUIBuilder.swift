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
        owner.dismissButton.layer.borderWidth = 1
        owner.dismissButton.layer.borderColor = UIColor.STGray.cgColor
        
        let tableViewBottomInset = owner.tableView.bounds.height - (owner.dismissButton.frame.minY - 14)
        owner.tableView.contentInset = .init(top: tableViewTopInset, left: 0, bottom: tableViewBottomInset, right: 0)
        owner.tableView.scrollIndicatorInsets = .init(top: tableViewTopInset, left: 0, bottom: 0, right: 0)
        owner.tableView.separatorInset = .init(top: 0, left: 16.5, bottom: 0, right: 16.5)
        
        PlacesListViewsFactory().registerPlaceListCell(to: owner.tableView)
        
    }
    
}
