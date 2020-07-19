//
//  PlacePreviewViewBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 19.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import FlexiblePageControl

class PlacePreviewViewBehaviorService: NSObject {
    
    //MARK: Variables
    unowned(unsafe) let owner: PlacePreviewView
    var model: PlaceModel!
    
    init(owner: PlacePreviewView) {
        self.owner = owner
    }
    
    func setup() {
        owner.backgroundColor = .clear
        owner.translatesAutoresizingMaskIntoConstraints = false
        
        Bundle.main.loadNibNamed(String(describing: type(of: owner)), owner: owner, options: nil)
        
        owner.addSubview(owner.contentView)
        
        owner.contentView.translatesAutoresizingMaskIntoConstraints = false
        owner.contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            owner.contentView.topAnchor.constraint(equalTo: owner.topAnchor),
            owner.contentView.leadingAnchor.constraint(equalTo: owner.leadingAnchor),
            owner.contentView.trailingAnchor.constraint(equalTo: owner.trailingAnchor),
            owner.contentView.bottomAnchor.constraint(equalTo: owner.bottomAnchor)
        ])
        
        owner.nameLabel.font = .titles
        owner.priceLabel.font = .subtitles
        owner.addressLabel.font = .mainText
        
        owner.textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        
        owner.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        owner.collectionView.decelerationRate = .fast
        
        owner.pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.6)
        owner.pageControl.currentPageIndicatorTintColor = .white
        
        let config = FlexiblePageControl.Config(displayCount: 7, dotSize: 5.06, dotSpace: 1.78, smallDotSizeRatio: 3.15 / 5.06, mediumDotSizeRatio: 4.31 / 5.06)
        owner.pageControl.setConfig(config)
        
    }
    
    //MARK: - Helpers
    func setupData(_ model: PlaceModel) {
        
        self.model = model
        
        owner.collectionView.backgroundColor = .STGraphite
        
        owner.nameLabel.text = model.name
        owner.nameLabelHeightConstr.constant = owner.nameLabel.sizeThatFits(CGSize(width: owner.nameLabel.bounds.width, height: .infinity)).height
        
        owner.priceLabel.text = "\(Int(model.minPrice))₽"
        owner.priceLabelHeightConstr.constant = owner.priceLabel.sizeThatFits(CGSize(width: owner.priceLabel.bounds.width, height: .infinity)).height
        
        owner.addressLabel.text = model.address
        owner.addressLabelHeightConstr.constant = owner.addressLabel.sizeThatFits(CGSize(width: owner.addressLabel.bounds.width, height: .infinity)).height
        
        let textViewText = model.phone + (model.email != nil ? "\n\(model.email!)" : "")
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.STText, .font: UIFont.mainText]
        let attrText = NSMutableAttributedString(string: textViewText, attributes: attributes)
        
        owner.textView.linkTextAttributes = attributes
        owner.textView.attributedText = attrText

        self.owner.textView.sizeToFit()
        self.owner.textViewHeightConstr.constant = self.owner.textView.contentSize.height
        
        owner.collectionView.dataSource = self
        owner.collectionView.delegate = self
        
        owner.pageControl.isHidden = model.imagesCount == 1
        owner.pageControl.numberOfPages = model.imagesCount
        owner.pageControl.setProgress(contentOffsetX: owner.collectionView.contentOffset.x, pageWidth: owner.collectionView.bounds.width)
        
        DispatchQueue.main.async {
            self.updateCollectionRadius()
        }
    }
    
    func updateCollectionRadius() {
        owner.collectionView.layer.cornerRadius = owner.collectionView.bounds.height / 2
    }
    
}

extension PlacePreviewViewBehaviorService: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var reuseIdentifier: String { return "PlacePreviewImageCollectionCell" }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.clipsToBounds = true
        
        let imageView: UIImageView
        
        if (cell.contentView.subviews.first as? UIImageView) != nil {
            imageView = cell.contentView.subviews.first as! UIImageView
        } else {
            imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        }
        
        imageView.kf.setImage(with: model.imagesLinks[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        owner.pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
}
