//
//  FiltersUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 26.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class FiltersUIBuilder: ServiceType {
    typealias Owner = FiltersViewController
    
    //MARK: Owner
    unowned(unsafe) let owner: FiltersViewController
    
    //MARK: - Views
    let closeItem = UIBarButtonItem(image: UIImage(named: "closeButtonIcon")!, style: .plain, target: nil, action: nil)
    
    //MARK: - Initialization
    required init(owner: FiltersViewController) {
        self.owner = owner
    }
    
    //MARK: - Setups
    func setup() {
        owner.title = "Отфильтровать"
        owner.navigationItem.leftBarButtonItem = closeItem
        closeItem.tintColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1)
    }
    
    
    
}
