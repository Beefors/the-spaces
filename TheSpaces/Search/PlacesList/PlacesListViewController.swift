//
//  PlacesListViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 14.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class PlacesListViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var containerBottomConstr: NSLayoutConstraint!
    
    //MARK: - Services
    var builderUI: PlacesListUIBuilder!
    var behaviorService: PlacesListBehaviorService!
    
    //MARK: - Views
    var searchPanelView: SearchPanelView!
    
    //MARK: - States
    private var setuped = false
    
    //MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !setuped else { return }
        commonSetup()
    }
    
    //MARK: - Helpers
    private func commonSetup() {
        setuped = true
        builderUI.setup()
        behaviorService.setup()
    }
    
}
