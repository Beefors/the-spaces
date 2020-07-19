//
//  PlaceModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 11.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

struct PlaceModel: Decodable {
    let id: Int
    let name: String
    let address: String
    let phone: String
    let email: String?
    let cityName: String
    let entityTypeName: String
    let metroStationName: String
    let workingHours: String?
    let hasFrontDesk: Bool?
    let hasKitchen: Bool?
    let hasDrinks: Bool?
    let hasWiFi: Bool?
    let hasGuests: Bool?
    let hasMeetingRooms: Bool?
    let hasPhone: Bool?
    let hasConferenceHall: Bool?
    let latitude: Double
    let longtitude:Double
    let priceRange: String
    let imagesCount: Int
    let seatTypes: [SeatType]
    
    var imagesLinks: [URL] {
        return (1 ... imagesCount).map { (value) -> URL in
            let target = ApiProvider.placeImage(placeId: id, imageNumber: value)
            return target.baseURL.appendingPathComponent(target.path)
        }
    }
    
}

struct SeatType: Decodable {
    let seatTypeName: String
    let paymentTypeName: String
    let price: Float
}

extension PlaceModel {
    var minPrice: Float {
        return seatTypes.map { (seatType) -> Float in
            return seatType.price
        }.min() ?? 0
    }
}
