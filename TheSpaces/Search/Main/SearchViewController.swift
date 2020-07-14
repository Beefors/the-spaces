//
//  SearchViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit
import YandexMapKit

class SearchViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var searchPanelView: SearchPanelView!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var showListButton: UIButton!
    
    //MARK: - Services
    lazy var builderUI = SearchVCUIBuilder(self)
    lazy var behaviorService = SearchVCBehaviorService(self)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        builderUI.buildUI()
        behaviorService.setup()
    }

}
