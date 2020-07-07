//
//  SearchViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Поиск"
        
        view.backgroundColor = .red
        
        tabBarController?.tabBar.subviews.first?.layer.backgroundColor = UIColor.blue.cgColor
        tabBarController?.tabBar.subviews.first?.layer.cornerRadius = 20
        
    }

}
