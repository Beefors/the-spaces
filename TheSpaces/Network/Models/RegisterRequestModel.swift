//
//  RegisterRequestModel.swift
//  TheSpaces
//
//  Created by Александр Михеев on 28.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//
    
import Foundation

struct RegisterRequestModel: Encodable {
    let email: String
    let lastName: String
    let firstName: String
    let birthDate: Date?
    let specialization: String?
    let phoneNumber: String
    let password: String
}
