//
//  CollectionViewCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class CheckmarkCell: UICollectionViewCell {
    static let identifier = "CheckmarkCell"
    
    @IBOutlet weak var checkButton: CheckButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkButton.contentInset.top = 8.2
        checkButton.contentInset.bottom = 8.2
    }
    
}
