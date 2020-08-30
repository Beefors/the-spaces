//
//  FiltersDataSource.swift
//  TheSpaces
//
//  Created by Денис Швыров on 26.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

struct FiltersDataSource {
    
    var sections: [Sections] {
        return [.prices(types: Sections.PricesTypes.allCases),
                .specifications(types: Sections.SpecificationsTypes.allCases),
                .services(types: Sections.ServicesTypes.allCases),
                .equipment(types: Sections.EquipmentTypes.allCases),
                .facilities(types: Sections.FacilitiesTypes.allCases),
                .transport(types: Sections.TransportTypes.allCases)]
    }
    
    enum Sections {
        
        // Price case
        enum PricesTypes: CaseIterable {
            case day
            case month
        }
        
        case prices(types: [PricesTypes])
        
        // Specifications case
        enum SpecificationsTypes: CaseIterable {
            case metro
            case roominess
            case working
        }
        
        case specifications(types: [SpecificationsTypes])
        
        // Services case
        enum ServicesTypes: CaseIterable {
            case Reception
            case cityNumber
            case guests
            case legalAddress
        }
        
        case services(types: [ServicesTypes])
        
        // Equipment case
        enum EquipmentTypes: CaseIterable {
            case wifi
            case printer
            case scanner
            case colorPrinter
            case meetingRooms
            case phoneBooth
            case conferenceHall
        }
        
        case equipment(types: [EquipmentTypes])
        
        // Facilities case
        enum FacilitiesTypes: CaseIterable {
            case loungeArea
            case kitchen
            case yogaStudio
            case shower
            case boxForThings
            case freeDrinks
        }
        
        case facilities(types: [FacilitiesTypes])
        
        // Transport case
        enum TransportTypes: CaseIterable {
            case freeParking
            case bicycleParking
        }
        
        case transport(types: [TransportTypes])
    }
    
}

extension FiltersDataSource.Sections {
    var rowsCount: Int {
        switch self {
        case .prices(let types): return types.count
        case .specifications(let types): return types.count
        case .services(let types): return types.count
        case .equipment(let types): return types.count
        case .facilities(let types): return types.count
        case .transport(let types): return types.count
        }
    }
}
