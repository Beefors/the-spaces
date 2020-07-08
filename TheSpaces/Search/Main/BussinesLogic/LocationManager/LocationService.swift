//
//  LocationService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

class LocationService: NSObject {
    
    unowned(unsafe) private(set) var parent: SearchViewController
    
    
    
    init(parent: SearchViewController) {
        self.parent = parent
        super.init()
    }
    
}
