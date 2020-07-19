//
//  SearchPlacePreviewService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 19.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class SearchPlacePreviewService: NSObject {
    
    unowned(unsafe) let owner: SearchViewController
    
    let previewContainer: UIView
    let placeView: PlacePreviewView
    
    private var showedConstraintValue = CGFloat()
    private var hidedConstraintValue = CGFloat()
    
    init(owner: SearchViewController) {
        self.owner = owner
        
        previewContainer = UIView()
        previewContainer.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.backgroundColor = .white

        placeView = PlacePreviewView()
        placeView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup() {
        
        owner.view.insertSubview(previewContainer, belowSubview: owner.searchPanelView)
        
        let widthMultiplier: CGFloat = 340 / 375
        let padding = (owner.view.bounds.width - owner.view.bounds.width * widthMultiplier) / 2
        
        NSLayoutConstraint.activate([
            previewContainer.widthAnchor.constraint(equalTo: owner.view.widthAnchor, multiplier: widthMultiplier),
            owner.showListButton.topAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: 15),
            owner.view.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor, constant: padding)
        ])
        
        showedConstraintValue = padding
        hidedConstraintValue = previewContainer.bounds.width
        
        previewContainer.addSubview(placeView)
        
        NSLayoutConstraint.activate([
            placeView.topAnchor.constraint(equalTo: previewContainer.topAnchor, constant: 10),
            placeView.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 11),
            previewContainer.trailingAnchor.constraint(equalTo: placeView.trailingAnchor, constant: 11),
            previewContainer.bottomAnchor.constraint(equalTo: placeView.bottomAnchor, constant: 10)
        ])
        
        placeView.collectionView.isScrollEnabled = false
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        previewContainer.addGestureRecognizer(pan)
        
    }
    
    func setupData(_ model: PlaceModel) {
        placeView.behaviorService.setupData(model)
        placeView.pageControl.isHidden = true
        
        DispatchQueue.main.async {
            self.previewContainer.layer.cornerRadius = self.previewContainer.bounds.height / 2
            self.setupShadow()
        }
    }
    
    func setupShadow() {
        previewContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        previewContainer.layer.shadowOffset = CGSize(width: 3, height: 5)
        previewContainer.layer.shadowOpacity = 1
        previewContainer.layer.shadowRadius = 20
        let shadowPath = UIBezierPath(roundedRect: previewContainer.bounds, cornerRadius: previewContainer.layer.cornerRadius)
        previewContainer.layer.shadowPath = shadowPath.cgPath
    }
    
    @objc func handlePan (recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: owner.view)
        
        print(translation)
        
        
        
//        switch recognizer.state {
//        case .began:
//            startPanning()
//        case .changed:
//            scrub(translation: translation)
//        case .ended:
//            print("Ended animation")
//            end()
//        default:
//            print("Something went wrong")
//        }
    }
    
}
