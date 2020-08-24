//
//  SearchHistoryHeaderView.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class SearchHistoryHeaderView: UIView {
    
    let label = UILabel()
    let button = UIButton()
    
    private var labelLeadingConstr: NSLayoutConstraint!
    private var buttonTrailingConstr: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        labelLeadingConstr = label.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            labelLeadingConstr,
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        buttonTrailingConstr = trailingAnchor.constraint(equalTo: button.trailingAnchor)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            buttonTrailingConstr,
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 8)
        ])
        
        label.font = UIFont.tabbarTitles
        label.textColor = UIColor.STText
        
        label.text = "История"
        
        button.titleLabel?.font = .tabbarTitles
        button.setTitleColor(.STGrayUnderline, for: .normal)
        
        button.setTitle("Очистить", for: .normal)
        
    }
    
    func setupLabelLeadingOffset(_ value: CGFloat) {
        labelLeadingConstr.constant = value
    }
    
    func setButtonTrailingOffset(_ value: CGFloat) {
        buttonTrailingConstr.constant = value
    }
    
}
