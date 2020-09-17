//
//  FiltersRadioButtonViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class FiltersRadioButtonViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    lazy var beheviorService = FiltersRadioButtonBehaviorService(owner: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beheviorService.setup()
    }
    

}
