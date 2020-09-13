//
//  FilterSubtitleCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 30.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class FilterSubtitleCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = .filterParam
        label.textColor = .STText
        
        subtitleLabel.font = .choiceGray
        subtitleLabel.textColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    }
}
