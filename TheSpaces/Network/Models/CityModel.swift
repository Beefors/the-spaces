//
//  CityModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 12.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

struct CityModel: Decodable {
    let id: Int
    let name: String
    let hasMetro: Bool
}
