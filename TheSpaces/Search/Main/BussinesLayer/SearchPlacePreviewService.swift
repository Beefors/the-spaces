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
    
    private(set) var previewIsHidden = true {
        didSet {
            print("PreviewService preview did \(previewIsHidden ? "hidden" : "showed")")
        }
    }
    
    let previewContainer: UIView
    let placeView: PlacePreviewView
    
    private var previewContainerLeadingConstr: NSLayoutConstraint!
    private var previewContainerCenterXConstr: NSLayoutConstraint!
    
    private var animator: UIViewPropertyAnimator!
    
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
        
        previewContainerLeadingConstr = previewContainer.leadingAnchor.constraint(equalTo: owner.view.trailingAnchor)
        previewContainerCenterXConstr = previewContainer.centerXAnchor.constraint(equalTo: owner.view.centerXAnchor)
        
        NSLayoutConstraint.activate([
            previewContainer.widthAnchor.constraint(equalTo: owner.view.widthAnchor, multiplier: 340 / 375),
            owner.showListButton.topAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: 15),
            previewContainerLeadingConstr
        ])
        
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
        
        createAnimator(forHiddedState: !previewIsHidden)
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
    
    var pausedFraction = CGFloat()
    
    @objc
    func handlePan (recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: owner.view)
        let horizontalValue = translation.x * (previewIsHidden && !animator.isReversed ? -1 : 1)
        
        let horizontalVelosity = recognizer.velocity(in: owner.view).x
        
        switch recognizer.state {
        case .began:
            
            if animator.isRunning {
                animator.pauseAnimation()
                pausedFraction = animator.fractionComplete
            }
            
            print("PreviewService began handlePan animator fractionComplete \(String(describing: animator?.fractionComplete))")
        case .changed:
            let fractionComplete = horizontalValue / owner.view.bounds.width + pausedFraction
            let result = !animator.isReversed ? fractionComplete : 1 - fractionComplete
            animator.fractionComplete = result
            print("PreviewService pan changed animator.isReversed: \(animator.isReversed) fractionComplete: \(fractionComplete) result: \(result)")
            
        case .ended, .cancelled, .failed:
            
            pausedFraction = CGFloat()
            
            let fraction = animator.fractionComplete
//            animator.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .easeInOut), durationFactor: CGFloat(animator.duration) * (1 - fraction))
            
            if fraction < 0.3 {
                animator.isReversed = true
            }
            
            animator.startAnimation()
            
            print("PreviewService Ended handlePan")
//            end()
        default:
            print("Something went wrong")
        }
    }
    
    func showPreview() {
        
        guard previewIsHidden else { return }
        
        owner.view.layoutIfNeeded()
        animator.startAnimation()
    }
    
    private func setupConstraints(forHiddedState willBeHidden: Bool) {
        self.previewContainerLeadingConstr.isActive = willBeHidden
        self.previewContainerCenterXConstr.isActive = !willBeHidden
    }
    
    private func createAnimator(forHiddedState willBeHidden: Bool) {
        
        let animationFuction: UIView.AnimationCurve = willBeHidden ? .easeIn : .easeOut
        
        let animator = UIViewPropertyAnimator(duration: 5.3, curve: animationFuction) {[unowned self] in
            self.setupConstraints(forHiddedState: willBeHidden)
            self.owner.view.layoutIfNeeded()
        }
        
        animator.addCompletion {[unowned self] (position) in
            if position == .end {
                self.previewIsHidden = !self.previewIsHidden
                self.createAnimator(forHiddedState: !self.previewIsHidden)
            } else {
                self.createAnimator(forHiddedState: self.previewIsHidden)
            }
        }
        
        self.animator = animator
    }
    
}
