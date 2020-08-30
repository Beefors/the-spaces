//
//  ServiceType.swift
//  TheSpaces
//
//  Created by Денис Швыров on 26.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

protocol ServiceType: class {
    associatedtype Owner
    var owner: Owner { get }
    init(owner: Owner)
    func setup()
}
