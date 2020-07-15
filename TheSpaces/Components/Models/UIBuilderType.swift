//
//  UIBuilderType.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

protocol UIBuilderType: class {
    func buildUI()
    func refreshUI()
}

extension UIBuilderType {
    func refreshUI() {}
}
