//
//  PlacesFilter.swift
//  TheSpaces
//
//  Created by Денис Швыров on 13.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

protocol PlacesFilterType {
    var key: String {get}
    var value: Any {get}
}

struct PlacesFilter: PlacesFilterType {
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
