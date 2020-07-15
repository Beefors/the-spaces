//
//  RxSectionModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 15.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxDataSources

struct RxSectionModel<Item>: SectionModelType {
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    init(original: RxSectionModel<Item>, items: [Item]) {
        self.items = items
    }
}

extension RxSectionModel: Equatable where Item: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.items == rhs.items
    }
}
