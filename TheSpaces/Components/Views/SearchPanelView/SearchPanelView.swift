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
    
    let textField = UITextField()
    let optionsButton = UIButton()
    
    private let textFieldLeftAccesoryView = UIView()
    
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
            self.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        optionsButton.backgroundColor = .white
        optionsButton.setImage(#imageLiteral(resourceName: "paramsIcon"), for: .normal)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.layer.cornerRadius = 6
        optionsButton.layer.borderWidth = 1
        optionsButton.layer.borderColor = UIColor.STGray.cgColor
        addSubview(optionsButton)
        
        NSLayoutConstraint.activate([
            optionsButton.heightAnchor.constraint(equalToConstant: 36),
            optionsButton.widthAnchor.constraint(equalToConstant: 36),
            optionsButton.topAnchor.constraint(equalTo: topAnchor),
            trailingAnchor.constraint(equalTo: optionsButton.trailingAnchor, constant: 16.5)
        ])
        
        textField.placeholder = "Поиск"
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 18
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.STGray.cgColor
        
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 36),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.5),
            optionsButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 9)
        ])
        
        textFieldLeftAccesoryView.backgroundColor = .clear
        textFieldLeftAccesoryView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.leftView = textFieldLeftAccesoryView
        textField.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            textFieldLeftAccesoryView.widthAnchor.constraint(equalToConstant: 40),
            textFieldLeftAccesoryView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "magnifierIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldLeftAccesoryView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: textFieldLeftAccesoryView.centerXAnchor, constant: 3),
            imageView.centerYAnchor.constraint(equalTo: textFieldLeftAccesoryView.centerYAnchor)
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
        
        let searchBarShadowPath = UIBezierPath(roundedRect: textField.bounds, cornerRadius: 18)
        textField.layer.shadowPath = searchBarShadowPath.cgPath
        textField.layer.shadowColor = UIColor(red: 0.375, green: 0.367, blue: 0.367, alpha: 0.15).cgColor
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 20
        textField.layer.shadowOffset = CGSize(width: 3, height: 5)
        
    }
    
    //MARK: Helpers
    func transite(to superView: UIView) {
        removeFromSuperview()
        superView.addSubview(self)
        
        let superViewTopAnchor: NSLayoutYAxisAnchor
        
        if #available(iOS 11.0, *) {
            superViewTopAnchor = superView.safeAreaLayoutGuide.topAnchor
        } else {
            superViewTopAnchor = superView.topAnchor
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superViewTopAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor)
        ])
    }
    
}
