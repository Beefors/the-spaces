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
    let cityId: Int
    let cityName: String
    let entityTypeId: Int
    let entityTypeName: String
    let metroStationName: String
    let distanceFromMetroInMeters: Double?
    let workingHours: String?
    let hasAlldayAccess: Bool?
    let isWorksOnWeekend: Bool?
    
    let hasFrontDesk: Bool?
    let hasKitchen: Bool?
    let hasFreeDrinks: Bool?
    let hasWiFi: Bool?
    let hasGuests: Bool?
    let hasMeetingRooms: Bool?
    let hasPhone: Bool?
    let hasLandline: Bool?
    let canProvideLegalAddress: Bool?
    let hasConferenceHall: Bool?
    let hasBWPrinter: Bool?
    let hasColorPrinter: Bool?
    let hasScanner: Bool?
    let hasLounge: Bool?
    let hasYoga: Bool?
    let hasBath: Bool?
    let hasThingsBox: Bool?
    let hasFreeParking: Bool?
    let hasBikeParking: Bool?
    let latitude: Double
    let longtitude:Double
    let priceRange: String
    let imagesCount: Int
    let isActive: Bool?
    let seatTypes: [SeatType]
    
    var imagesLinks: [URL] {
        return (1 ... imagesCount).map { (value) -> URL in
            let target = ApiProvider.placeImage(placeId: id, imageNumber: value)
            return target.baseURL.appendingPathComponent(target.path)
        }
    }
    
}

enum SeatModelMap: String {
    case day = "В день"
    case week = "За неделю"
    case month = "В месяц"
}

struct SeatType: Decodable {
    let id: Int
    let seatTypeId: Int
    let seatTypeName: String
    let capacity: Int
    let paymentTypes: [PaymentType]
    
    
}

struct PaymentType: Decodable {
    let entitySeatTypeId: Int
    let paymentType: Int
    let paymentTypeName: String
    let price: Float
    
    var modelMap: SeatModelMap? {
        return SeatModelMap(rawValue: paymentTypeName)
    }
}

extension PlaceModel {
    var minPrice: Float {
        return seatTypes.map { (seatType) -> Float in
            return seatType.price
        }.min() ?? 0
    }
    
    func seatType(by modelMap: SeatModelMap) -> SeatType? {
        return seatTypes.first(where: { $0.modelMap == modelMap })
    }
    
}

extension PlaceModel: Equatable {
    static func == (lhs: PlaceModel, rhs: PlaceModel) -> Bool {
        lhs.id == rhs.id
    }
}
