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
    let accessTokenExpiresAt: String
    let refreshTokenExpiresAt: String
    
    var accessTokenExpiresDate: Date {
        dateFromString(accessTokenExpiresAt)
    }
    
    var refreshTokenExpiresDate: Date {
        dateFromString(refreshTokenExpiresAt)
    }
    
    private func dateFromString(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        return formatter.date(from: string) ?? Date()
    }
    
}
