//
//  MapPlacePreviewService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 19.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

protocol SearchPlacePreviewServiceDelegate: class {
    func placePreviewService(_ service: MapPlacePreviewService, didHidePreviewForPlace place: PlaceModel)
}

class MapPlacePreviewService: NSObject {
    
    unowned(unsafe) let owner: MapViewController
    weak var delegate: SearchPlacePreviewServiceDelegate?
    
    private(set) var previewIsHidden = true {
        didSet {
            guard previewIsHidden else { return }
            delegate?.placePreviewService(self, didHidePreviewForPlace: placeView.behaviorService.model)
        }
    }
    
    let previewContainer: UIView
    let placeView: PlacePreviewView
    
    private var previewContainerLeadingConstr: NSLayoutConstraint!
    private var previewContainerCenterXConstr: NSLayoutConstraint!
    
    private var positionAnimator: UIViewPropertyAnimator!
    private var blinkAnimator: UIViewPropertyAnimator!
    
    init(owner: MapViewController) {
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
        
        previewContainerLeadingConstr.priority = UILayoutPriority(rawValue: 900)
        
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
        
        createPositionAnimator(forHiddedState: false)
    }
    
    func setupData(_ model: PlaceModel) {
        
        guard placeView.behaviorService.model != model else { return }
        
        placeView.behaviorService.setupData(model)
        placeView.pageControl.isHidden = true
        
        DispatchQueue.main.async {
            self.previewContainer.layer.cornerRadius = self.previewContainer.bounds.height / 2
            self.setupShadow()
        }
    }
    
    private func setupShadow() {
        previewContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        previewContainer.layer.shadowOffset = CGSize(width: 3, height: 5)
        previewContainer.layer.shadowOpacity = 1
        previewContainer.layer.shadowRadius = 20
        let shadowPath = UIBezierPath(roundedRect: previewContainer.bounds, cornerRadius: previewContainer.layer.cornerRadius)
        previewContainer.layer.shadowPath = shadowPath.cgPath
    }
    
    var pausedFraction = CGFloat()
    
    @objc
    private func handlePan (recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: owner.view)
        let horizontalValue = positionAnimator.isReversed && !previewIsHidden || !positionAnimator.isReversed && previewIsHidden ? -translation.x : translation.x
        
        switch recognizer.state {
        case .began:
            
            if positionAnimator.isRunning {
                positionAnimator.pauseAnimation()
                pausedFraction = positionAnimator.fractionComplete
            }
            
        case .changed:
            positionAnimator.fractionComplete = horizontalValue / owner.view.bounds.width + pausedFraction
            
        case .ended, .cancelled, .failed:
            
            pausedFraction = CGFloat()
            let horizontalVelosity = recognizer.velocity(in: owner.view).x
            
            let obligedToHide = horizontalVelosity > 1000
            
            let ratio: CGFloat
            let duration: CGFloat
            
            if obligedToHide {
                positionAnimator.isReversed = previewIsHidden && !positionAnimator.isReversed //|| !(!previewIsHidden && animator.isReversed)
                ratio = 1
                duration = 0.4
            } else {
                
                duration = 1
                
                let isReversedAnimation = positionAnimator.isReversed
                let needCombackAnimation = isReversedAnimation ? positionAnimator.fractionComplete < 0.6 : positionAnimator.fractionComplete < 0.4
                
                switch (isReversedAnimation, needCombackAnimation) {
                case (false, true): positionAnimator.isReversed = true
                case (true, true): positionAnimator.isReversed = false
                default: break
                }
                
                let absVelosity = abs(horizontalVelosity)
                
                if absVelosity < 200 {
                    ratio = 1.0
                } else if absVelosity < 1000 {
                    ratio = 0.5
                } else {
                    ratio = 0.2
                }
            }
            
            positionAnimator.continueAnimation(withTimingParameters: UISpringTimingParameters(dampingRatio: ratio), durationFactor: duration)
            
        default: break
        }
    }
    
    func showPreview(withPlace place: PlaceModel) {
        
        if previewIsHidden {
            owner.view.layoutIfNeeded()
            positionAnimator.startAnimation()
        } else if positionAnimator.isRunning, !positionAnimator.isReversed {
            positionAnimator.isReversed = true
        }
        
        if !previewIsHidden {
            
            createBlinkAnimator {[unowned self] in
                self.setupData(place)
            }
            
            blinkAnimator.startAnimation()
        } else {
            setupData(place)
        }
        
    }
    
    private func setupConstraints(forHiddedState isHidden: Bool) {
        self.previewContainerCenterXConstr.isActive = !isHidden
    }
    
    private func createPositionAnimator(forHiddedState willBeHidden: Bool) {
        
        let animator = UIViewPropertyAnimator(duration: 0.4, timingParameters: UISpringTimingParameters(dampingRatio: 0.7))
        
        animator.addAnimations({[unowned self] in
            self.setupConstraints(forHiddedState: willBeHidden)
            self.owner.view.layoutIfNeeded()
        })
        
        animator.addCompletion {[unowned self] (position) in
            if position == .end {
                self.previewIsHidden = willBeHidden
            } else {
                self.previewIsHidden = !willBeHidden
                self.setupConstraints(forHiddedState: self.previewIsHidden)
            }
            
            self.createPositionAnimator(forHiddedState: !self.previewIsHidden)
        }
        
        self.positionAnimator = animator
    }
    
    private func createBlinkAnimator(withAction action: (() -> ())?) {
        
        let firstActAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn, animations: nil)
        let secondActAnimator = UIViewPropertyAnimator(duration: 0.3, timingParameters: UISpringTimingParameters(dampingRatio: 0.5))
        
        firstActAnimator.addAnimations {[unowned self] in
            self.previewContainer.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.placeView.alpha = 0.5
        }
        
        firstActAnimator.addCompletion { (_) in
            secondActAnimator.startAnimation()
        }
        
        secondActAnimator.addAnimations {[unowned self] in
            self.previewContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.placeView.alpha = 1
            action?()
            self.owner.view.layoutIfNeeded()
        }
        
        blinkAnimator = firstActAnimator
    }
    
}
