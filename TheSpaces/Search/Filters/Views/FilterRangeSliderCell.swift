//
//  FilterRangeSliderCell.swift
//  TheSpaces
//
//  Created by Денис Швыров on 30.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RangeSeekSlider
import RxSwift
import RxCocoa

class FilterRangeSliderCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var subsliderView: UIView!
    
    let selectedRangeObservable = BehaviorRelay<FiltersViewModel.PriceRangeType>(value: (0,0))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.font = .filterParam
        label.textColor = .STText
        
        subsliderView.backgroundColor = .STBlue
        rangeSlider.lineHeight = 2
        rangeSlider.tintColor = .clear
        rangeSlider.handleColor = .STBlue
        rangeSlider.colorBetweenHandles = .STBlue
        
        rangeSlider.delegate = self
    }
    
    func set(lowerValue: CGFloat, upperValue: CGFloat) {

        func value(_ value: CGFloat, inRangeMinValue minValue: CGFloat, maxValue: CGFloat) -> Bool {
            return value >= minValue && value <= maxValue
        }
        
        rangeSlider.minValue = lowerValue
        
        if !value(rangeSlider.selectedMinValue, inRangeMinValue: lowerValue, maxValue: upperValue) {
            rangeSlider.selectedMinValue = lowerValue
        }
        
        rangeSlider.maxValue = upperValue
        
        if !value(rangeSlider.selectedMaxValue, inRangeMinValue: lowerValue, maxValue: upperValue) {
            rangeSlider.selectedMaxValue = upperValue
        }
        
        rangeSlider.layoutSubviews()
        selectedRangeObservable.accept((rangeSlider.selectedMinValue, rangeSlider.selectedMaxValue))
    }
    
}

extension FilterRangeSliderCell: RangeSeekSliderDelegate {
    func didEndTouches(in slider: RangeSeekSlider) {
        selectedRangeObservable.accept((slider.selectedMinValue, slider.selectedMaxValue))
    }
}
