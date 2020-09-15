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
//            case metro
            case working
            case roominess
        }
        
        case specifications(types: [SpecificationsTypes])
        
        // Services case
        enum ServicesTypes: CaseIterable {
            case reception
            case guests
            case cityNumber
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
    
    var title: String? {
        switch self {
        case .services: return "Услуги"
        case .equipment: return "Оборудование"
        case .facilities: return "Удобства"
        case .transport: return "Транспорт"
        default: return nil
        }
    }
}

protocol TitlePresentable {
    var title: String { get }
}

protocol FilterCheckmarkType: TitlePresentable, Hashable {
    var filterKey: String {get}
    init(filterKey: String)
}

extension FiltersDataSource.Sections.PricesTypes: FilterCheckmarkType {
    var title: String {
        switch self {
        case .day: return "Цена за день"
        case .month: return "Цена за месяц"
        }
    }
    
    var filterKey: String {
        switch self {
        case .day: return "pricePerDay"
        case .month: return "pricePerMonth"
        }
    }
    
    func filter(minValue: Int, maxValue: Int) -> PlacesFilter {
        return PlacesFilter.priceFilter(priceType: self, minValue: minValue, maxValue: maxValue)
    }
}

extension FiltersDataSource.Sections.SpecificationsTypes: TitlePresentable {
    var title: String {
        switch self {
        case .working: return "Режим работы"
        case .roominess: return "Вместимость\nопенспейса"
        }
    }
}

extension FilterCheckmarkType where Self: CaseIterable {
    init(filterKey: String) {
        self = Self.allCases.first(where: {$0.filterKey == filterKey})!
    }
}

extension FiltersDataSource.Sections.ServicesTypes: FilterCheckmarkType {
    var filterKey: String {
        switch self {
        case .reception: return "hasFrontDesk"
        case .cityNumber: return "hasLandline"
        case .guests: return "hasGuests"
        case .legalAddress: return "canProvideLegalAddress"
        }
    }
    
    var title: String {
        switch self {
        case .reception: return "Ресепшн"
        case .cityNumber: return "Прием ваших звонков на городской номер"
        case .guests: return "Доступ для гостей"
        case .legalAddress: return "Предоставление юридического адреса"
            
        }
    }
}
extension FiltersDataSource.Sections.EquipmentTypes: FilterCheckmarkType {
    var filterKey: String {
        switch self {
        case .wifi: return "hasWiFi"
        case .printer: return "hasBWPrinter"
        case .scanner: return "hasScanner"
        case .colorPrinter: return "hasColorPrinter"
        case .meetingRooms: return "hasMeetingRooms"
        case .phoneBooth: return "hasPhone"
        case .conferenceHall: return "hasConferenceHall"
        }
    }
    
    var title: String {
        switch self {
        case .wifi: return "Wi-Fi интернет"
        case .printer: return "Ч/б принтер"
        case .scanner: return "Сканер"
        case .colorPrinter: return "Цветная печать"
        case .meetingRooms: return "Переговорные комнаты"
        case .phoneBooth: return "Телефонная будка"
        case .conferenceHall: return "Конференц-зал"
        }
    }
}
extension FiltersDataSource.Sections.FacilitiesTypes: FilterCheckmarkType {
    var filterKey: String {
        switch self {
        case .loungeArea: return "hasLounge"
        case .kitchen: return "hasKitchen"
        case .yogaStudio: return "hasYoga"
        case .shower: return "hasBath"
        case .boxForThings: return "hasThingsBox"
        case .freeDrinks: return "hasFreeDrinks"
        }
    }
    
    var title: String {
        switch self {
        case .loungeArea: return "Лаунж-зона"
        case .kitchen: return "Кухня"
        case .yogaStudio: return "Йога-студия"
        case .shower: return "Душ"
        case .boxForThings: return "Ящик для вещей"
        case .freeDrinks: return "Бесплатные кофе/ чай"
        }
    }
}
extension FiltersDataSource.Sections.TransportTypes: FilterCheckmarkType {
    var filterKey: String {
        switch self {
        case .freeParking: return "hasFreeParking"
        case .bicycleParking: return "hasBikeParking"
        }
    }
    
    var title: String {
        switch self {
        case .freeParking: return "Бесплатная парковка"
        case .bicycleParking: return "Велопарковка"
        }
    }
}
