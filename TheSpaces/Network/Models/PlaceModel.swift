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
    let seatTypes: [SeatType]

}

struct SeatType: Decodable {
    let seatTypeName: String
    let paymentTypeName: String
    let price: Float
}
