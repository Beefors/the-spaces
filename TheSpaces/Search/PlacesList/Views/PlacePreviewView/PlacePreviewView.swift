//
//  PlacePreviewView.swift
//  TheSpaces
//
//  Created by Денис Швыров on 14.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit
import Kingfisher

class PlacePreviewView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewHeightConstr: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        nameLabel.font = .titles
        priceLabel.font = .subtitles
        addressLabel.font = .mainText
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageRadius()
    }
    
    func setupData(_ model: PlaceModel) {
        
//        imageView.kf.setImage(with: <#T##ImageDataProvider?#>)
//        imageView.backgroundColor = .STGraphite
        imageView.image = UIImage(named: "test")
        
        nameLabel.text = model.name + model.name + model.name + model.name
        priceLabel.text = "\(model.minPrice)"
        addressLabel.text = model.address
        textView.text = model.phone + " " + (model.email ?? "")
        
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        addressLabel.sizeToFit()
        textView.sizeToFit()
        
        textViewHeightConstr.constant = textView.contentSize.height
        
        updateImageRadius()
    }
    
    func updateImageRadius() {
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    
}
