//
//  YMKPoint + TS.swift
//  TheSpaces
//
//  Created by Денис Швыров on 02/04/2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import YandexMapKit
import CoreLocation

extension YMKPoint {
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D {
    func toYMKPoint() -> YMKPoint {
        return YMKPoint(latitude: latitude, longitude: longitude)
    }
}
