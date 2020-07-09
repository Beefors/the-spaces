//
//  SearchPanelView.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class SearchPanelView: UIView {
    
    let searchBar = UISearchBar()
    let optionsButton = UIButton()
    
    /// Size is ignoring
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: frame.origin, size: .zero))
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        optionsButton.backgroundColor = .white
        optionsButton.setImage(#imageLiteral(resourceName: "paramsIcon"), for: .normal)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.layer.cornerRadius = 6
        addSubview(optionsButton)
        
        NSLayoutConstraint.activate([
            optionsButton.heightAnchor.constraint(equalToConstant: 36),
            optionsButton.widthAnchor.constraint(equalToConstant: 36),
            optionsButton.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            trailingAnchor.constraint(equalTo: optionsButton.trailingAnchor, constant: 16.5)
        ])
        
        searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.5),
            optionsButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 9)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let optionsButtonShadowPath = UIBezierPath(roundedRect: optionsButton.bounds, cornerRadius: 6)
        optionsButton.layer.shadowPath = optionsButtonShadowPath.cgPath
        optionsButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        optionsButton.layer.shadowOpacity = 1
        optionsButton.layer.shadowRadius = 20
        optionsButton.layer.shadowOffset = CGSize(width: 3, height: 5)
        
        let searchBarShadowPath = UIBezierPath(roundedRect: searchBar.bounds, cornerRadius: 18)
        searchBar.layer.shadowPath = searchBarShadowPath.cgPath
        searchBar.layer.shadowColor = UIColor(red: 0.375, green: 0.367, blue: 0.367, alpha: 0.15).cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 20
        searchBar.layer.shadowOffset = CGSize(width: 3, height: 5)
        
    }
    
}
