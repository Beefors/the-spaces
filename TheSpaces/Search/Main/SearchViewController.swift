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
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var showListButton: UIButton!
    
    //MARK: - Views
    let mapView = YMKMapView()
    
    //MARK: - Variables
    var map: YMKMap { mapView.mapWindow.map }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupMap()
        setupUI()
    }
    
    //Support methods
    private func setupUI() {
        // Setup buttons
        userLocationButton.clipsToBounds = false
        userLocationButton.layer.masksToBounds = false
        userLocationButton.layer.cornerRadius = 6
        userLocationButton.backgroundColor = .white
        userLocationButton.layer.borderWidth = 1
        userLocationButton.layer.borderColor = UIColor.STGray.cgColor
        userLocationButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        userLocationButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        userLocationButton.layer.shadowOpacity = 1
        userLocationButton.layer.shadowRadius = 20
        userLocationButton.layer.shadowPath = UIBezierPath(roundedRect: userLocationButton.bounds, cornerRadius: userLocationButton.layer.cornerRadius).cgPath
        
        showListButton.clipsToBounds = false
        showListButton.layer.masksToBounds = false
        showListButton.layer.cornerRadius = 18
        showListButton.backgroundColor = .white
        showListButton.layer.borderWidth = 1
        showListButton.layer.borderColor = UIColor.STGray.cgColor
        showListButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        showListButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        showListButton.layer.shadowOpacity = 1
        showListButton.layer.shadowRadius = 20
        showListButton.layer.shadowPath = UIBezierPath(roundedRect: showListButton.bounds, cornerRadius: showListButton.layer.cornerRadius).cgPath
        showListButton.titleLabel?.font = .priceButton
        showListButton.setTitleColor(.STGraphite, for: .normal)
        showListButton.setTitle("Списком", for: .normal)
        
    }

}
