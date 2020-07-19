//
//  PlacePreviewView.swift
//  TheSpaces
//
//  Created by Денис Швыров on 14.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit
import Kingfisher
import FlexiblePageControl

class PlacePreviewView: UIView {

    //MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelsContainer: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: FlexiblePageControl!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelHeightConstr: NSLayoutConstraint!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelHeightConstr: NSLayoutConstraint!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressLabelHeightConstr: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewHeightConstr: NSLayoutConstraint!
    
    //MARK: - Service
    lazy private(set) var behaviorService = PlacePreviewViewBehaviorService(owner: self)
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        behaviorService.updateCollectionRadius()
    }
    
    //MARK: - Helpers
    private func commonInit() {
        behaviorService.setup()
    }
    
}
