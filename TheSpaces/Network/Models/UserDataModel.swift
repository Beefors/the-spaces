//
//  UserDataModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 11.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

struct UserDataModel: Codable {
    let email: String
    let lastName: String
    let firstName: String
    let phoneConfirmed: Bool
    let roles: Array<String>
}
