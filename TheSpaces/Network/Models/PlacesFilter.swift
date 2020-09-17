//
//  PlacesFilter.swift
//  TheSpaces
//
//  Created by Денис Швыров on 13.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

protocol PlacesFilterType: Equatable {
    var key: String {get}
    var value: Any {get}
}

struct PlacesFilter: PlacesFilterType {
    static func == (lhs: PlacesFilter, rhs: PlacesFilter) -> Bool {
        guard lhs.key == rhs.key else { return false }
        
        if let lhsValueDict = lhs.value as? Dictionary<String, Int>, let rhsValueDict = rhs.value as? Dictionary<String, Int> {
            return lhsValueDict == rhsValueDict
        } else if let lhsValue = lhs.value as? Int, let rhsValue = rhs.value as? Int {
            return lhsValue == rhsValue
        }
        
        return true
    }
    
    let key: String
    let value: Any
}

extension PlacesFilter {
    static func nameFilter(name: String) -> PlacesFilter {
        return PlacesFilter(key: "name", value: name)
    }
    
    static func priceFilter(priceType: FiltersDataSource.Sections.PricesTypes, minValue: Int, maxValue: Int) -> PlacesFilter {
        let value = ["min": minValue, "max": maxValue]
        return PlacesFilter(key: priceType.filterKey, value: value)
    }
    
}
