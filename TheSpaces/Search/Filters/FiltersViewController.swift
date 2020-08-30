//
//  FiltersViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 26.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Services
    lazy var behaviorService = FilterBehaviorService(owner: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        behaviorService.setup()
    }

}
