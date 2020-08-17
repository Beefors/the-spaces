//
//  SearchResultItemCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 14.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class SearchResultItemCell: UITableViewCell {
    static var reuseIdentifier = String(describing: self)
    
    let label = UILabel()
    private(set) var labelLeadingConstr: NSLayoutConstraint!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    func commonInit() {
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        labelLeadingConstr = label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: label.topAnchor),
            labelLeadingConstr,
            trailingAnchor.constraint(equalTo: label.trailingAnchor),
            bottomAnchor.constraint(equalTo: label.bottomAnchor)
        ])
        
        label.font = UIFont.subtitles.withSize(12)
    }
    
    func setupLabelLeadingOffset(_ value: CGFloat) {
        labelLeadingConstr.constant = value
    }
    
}
