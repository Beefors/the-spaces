//
//  FilterParamsCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 30.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit
import TagListView

class FilterParamsCell: UITableViewCell {

    @IBOutlet weak var tagList: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
