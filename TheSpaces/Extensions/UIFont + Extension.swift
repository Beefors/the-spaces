//
//  UIFont + Extension.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// SFCompactDisplay-Medium size: 12
    class var tabbarTitles: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    /// SFCompactDisplay-Medium size: 14
    class var priceButton: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    /// SFCompactDisplay-Regular size: 18
    class var titles: UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .regular)
    }
    
    /// SFCompactDisplay-Regular size: 14
    class var subtitles: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    /// SFCompactDisplay-Regular size: 10
    class var mainText: UIFont {
        return UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    /// SFCompactDisplay-Medium size: 14
    class var filterParam: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
}
