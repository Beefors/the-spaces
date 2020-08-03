//
//  LocationService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAppState

class LocationService: NSObject {
    
    unowned(unsafe) private(set) var owner: MapViewController
    let viewModel = LocationServiceViewModel()
 
    init(parent: MapViewController) {
        self.owner = parent
        super.init()
    }
    
    func setup() {
        
        owner.rx
            .viewDidAppear
            .subscribe(onNext: {[unowned self] (animated) in
                self.viewModel.requestPermissions()
            })
            .disposed(by: viewModel)
        
    }
    
}
