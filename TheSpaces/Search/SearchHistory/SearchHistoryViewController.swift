//
//  SearchHistoryViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class SearchHistoryViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewTopConstr: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstr: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeadingConstr: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailingConstr: NSLayoutConstraint!
    
    //MARK: - Services
    lazy var behaviorService = SearchHistoryBehaviorService(owner: self)
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        behaviorService.setup()
    }

    //MARK: - Helpers
    func setup(byParent parent: MapViewController) {
        behaviorService.builderUI.setupTopInset(searchPanel: parent.searchPanelView)
    }
    
}
