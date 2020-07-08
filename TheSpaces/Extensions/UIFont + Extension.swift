//
//  UIFont + Extension.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

extension UIFont {
    class var tabbarTitles: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    class var priceButton: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    class var titles: UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .regular)
    }
    
    class var subtitles: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    class var mainText: UIFont {
        return UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
}
