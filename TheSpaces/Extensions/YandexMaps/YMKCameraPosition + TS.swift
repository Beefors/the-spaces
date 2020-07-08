//
//  YMKCameraPosition + TS.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import YandexMapKit

extension YMKCameraPosition {
    static var moscowCenter: YMKCameraPosition {
        return YMKCameraPosition(target: YMKPoint(latitude: 55.740707664199164, longitude: 37.606140286132785), zoom: 9.701303, azimuth: 0, tilt: 0)
    }
}
