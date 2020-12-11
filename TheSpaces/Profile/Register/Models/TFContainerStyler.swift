//
//  TFContainerStyler.swift
//  TheSpaces
//
//  Created by Денис Швыров on 11.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

protocol TFContainerStyler {}

enum TFBorderStyle {
    case normal
    case red
}

extension TFContainerStyler {
    func borderFor(textFieldContainer: UIView, style: TFBorderStyle) {
        
        let borderColor: CGColor
        
        switch style {
        case .normal: borderColor = UIColor.STGrayUnderline.cgColor
        case .red: borderColor = UIColor.STRed.cgColor
        }
        
        textFieldContainer.layer.borderColor = borderColor
    }
}
