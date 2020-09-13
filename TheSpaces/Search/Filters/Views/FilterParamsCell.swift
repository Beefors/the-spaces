//
//  FilterParamsCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 30.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class FilterParamsCell: UITableViewCell {
    static let identifier = "FilterParamsCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstr: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
