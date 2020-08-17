//
//  SearchHistoryItemCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class SearchHistoryItemCell: UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    let button = UIButton(type: .custom)
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
        // Initialization code
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
        
        button.setImage(UIImage(named: "removeHistoryItemIcon"), for: .normal)
        button.frame.size = CGSize(width: 10, height: 10)
        
        accessoryView = button
    }
    
    func setupLabelLeadingOffset(_ value: CGFloat) {
        labelLeadingConstr.constant = value
    }

}
