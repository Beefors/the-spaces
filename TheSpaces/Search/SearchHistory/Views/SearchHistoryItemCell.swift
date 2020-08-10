//
//  SearchHistoryItemCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class SearchHistoryItemCell: UITableViewCell {
    static var reuseIdentifier = String(describing: self)
    
    let button = UIButton(type: .custom)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        button.setTitle("X", for: .normal)
        accessoryView = button
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
