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

enum PaymentModelMap: Int {
    case day = 1
    case week = 2
    case month = 3
}

extension PaymentModelMap {
    var localizedDescription: String {
        switch self {
        case .day: return "В день"
        case .week: return "За неделю"
        case .month: return "В месяц"
        }
    }
}

struct SeatType: Decodable {
    let id: Int
    let seatTypeId: Int
    let seatTypeName: String
    let capacity: Int
    let paymentTypes: [PaymentType]
    
    var price: Float {
        return paymentTypes.map({$0.price}).min() ?? 0
    }
    
}

struct PaymentType: Decodable {
    let entitySeatTypeId: Int
    let paymentType: Int
    let paymentTypeName: String
    let price: Float
    
    var modelMap: PaymentModelMap? {
        return PaymentModelMap(rawValue: paymentType)
    }
}

extension PlaceModel {
    var minPrice: Float {
        return seatTypes.map { (seatType) -> Float in
            return seatType.price
        }.min() ?? 0
    }
    
    func seatType(by modelMap: PaymentModelMap) -> SeatType? {
        
        var seatType: SeatType?
        
        for type in seatTypes {
            guard type.paymentTypes.first(where: { $0.modelMap == modelMap }) != nil else { continue }
            seatType = type
            break
        }
        
        return seatType
    }
    
}

extension PlaceModel: Equatable {
    static func == (lhs: PlaceModel, rhs: PlaceModel) -> Bool {
        lhs.id == rhs.id
    }
}
