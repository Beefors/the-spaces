//
//  RadioButtonCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class RadioButtonCell: UITableViewCell {

    @IBOutlet weak var checkButton: CheckButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkButton.isSelected = selected
    }

}
