//
//  MapServiceType.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation.CLLocation

enum ZoomType: Int {
    case current
    case near
}

protocol MapServiceType: class {
    func setup()
    func goToLocation(_ location: CLLocationCoordinate2D, zoom zoomType: ZoomType, animated: Bool)
}
