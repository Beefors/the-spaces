//
//  SearchVCUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class SearchVCUIBuilder: UIBuilderType {
    unowned(unsafe) private(set) var controller: SearchViewController
    
    init(_ controller: SearchViewController) {
        self.controller = controller
    }
    
    func buildUI() {
        // Setup buttons
        controller.userLocationButton.clipsToBounds = false
        controller.userLocationButton.layer.masksToBounds = false
        controller.userLocationButton.layer.cornerRadius = 6
        controller.userLocationButton.backgroundColor = .white
        controller.userLocationButton.layer.borderWidth = 1
        controller.userLocationButton.layer.borderColor = UIColor.STGray.cgColor
        controller.userLocationButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        controller.userLocationButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        controller.userLocationButton.layer.shadowOpacity = 1
        controller.userLocationButton.layer.shadowRadius = 20
        controller.userLocationButton.layer.shadowPath = UIBezierPath(roundedRect: controller.userLocationButton.bounds, cornerRadius: controller.userLocationButton.layer.cornerRadius).cgPath
        
        controller.showListButton.clipsToBounds = false
        controller.showListButton.layer.masksToBounds = false
        controller.showListButton.layer.cornerRadius = 18
        controller.showListButton.backgroundColor = .white
        controller.showListButton.layer.borderWidth = 1
        controller.showListButton.layer.borderColor = UIColor.STGray.cgColor
        controller.showListButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        controller.showListButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        controller.showListButton.layer.shadowOpacity = 1
        controller.showListButton.layer.shadowRadius = 20
        controller.showListButton.layer.shadowPath = UIBezierPath(roundedRect: controller.showListButton.bounds, cornerRadius: controller.showListButton.layer.cornerRadius).cgPath
        controller.showListButton.titleLabel?.font = .priceButton
        controller.showListButton.setTitleColor(.STGraphite, for: .normal)
        controller.showListButton.setTitle("Списком", for: .normal)
    }
}
