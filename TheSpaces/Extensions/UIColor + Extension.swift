//
//  UIColor + Extension.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit.UIColor

extension UIColor {
    
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            return light
        }
    }
    
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    /// Голубой #53B1EF
    @nonobjc class var STBlue: UIColor {
        UIColor(red: 0.325, green: 0.694, blue: 0.937, alpha: 1)
    }
    
    /// Красный #E95456
    @nonobjc class var STRed: UIColor {
        UIColor(red: 0.914, green: 0.329, blue: 0.337, alpha: 1)
    }
    
    /// Фиолетовый #9E56EA
    @nonobjc class var STPurple: UIColor {
        UIColor(red: 0.914, green: 0.329, blue: 0.337, alpha: 1)
    }
    
    /// Зеленый #51CB98
    @nonobjc class var STGreen: UIColor {
        UIColor(red: 0.32, green: 0.8, blue: 0.6, alpha: 1)
    }
    
    /// Графит #605E5E
    @nonobjc class var STGraphite: UIColor {
        UIColor(red: 0.375, green: 0.367, blue: 0.367, alpha: 1)
    }
    
    /// Серый #E0DDDD
    @nonobjc class var STGray: UIColor {
        UIColor(red: 0.878, green: 0.867, blue: 0.867, alpha: 1)
    }
    
    /// Светло-серый #F3F2F2
    @nonobjc class var STLightGray: UIColor {
        UIColor(red: 0.953, green: 0.949, blue: 0.949, alpha: 1)
    }
    
    /// Серый подчеркивание #C4C4C4
    @nonobjc class var STGrayUnderline: UIColor {
        UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
    }
    
    /// Основной текст #333333
    @nonobjc class var STText: UIColor {
        UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    /// Cерый выбор #8F8E94
    @nonobjc class var STChoiceGray: UIColor {
        UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    }
    
}
