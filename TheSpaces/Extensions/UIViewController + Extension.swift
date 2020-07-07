//
//  UIViewController + Extension.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    var safeAreaTopInset: CGFloat {
        var value = CGFloat()
        
        if #available(iOS 11.0, *) {
            value = view.safeAreaInsets.top
        }
        
        return value
    }
    
    var safeAreaBottomInset: CGFloat {
        var value = CGFloat()
        
        if #available(iOS 11.0, *) {
            value = view.safeAreaInsets.bottom
        }
        
        return value
    }
    
}
