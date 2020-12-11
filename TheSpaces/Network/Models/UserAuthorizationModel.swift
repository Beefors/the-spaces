//
//  UserAuthorizationModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 11.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

struct UserAuthorizationModel: Codable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiresAt: Date
    let refreshTokenExpiresAt: Date
}
