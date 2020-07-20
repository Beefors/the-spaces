//
//  MapServiceViewsFactory.swift
//  TheSpaces
//
//  Created by Денис Швыров on 20.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class MapServiceViewsFactory {
    
    static func createMarkerView(isSelected: Bool, place: PlaceModel) -> UIView {
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 10.52, y: 5.44), size: .zero))
        label.font = .priceButton
        label.text = "\(Int(place.minPrice))₽"
        
        label.sizeToFit()
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: label.frame.maxX + 8.35, height: label.frame.maxY + 4.94)))
        view.addSubview(label)
        view.backgroundColor = isSelected ? .STBlue : .white
        view.layer.cornerRadius = view.bounds.height / 2
        view.isOpaque = false
        view.layer.borderColor = UIColor.STLightGray.cgColor
        view.layer.borderWidth = 1
        
        return view
    }
    
}
