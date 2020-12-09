//
//  UserRegisterModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

struct UserRegisterModel {
    var name: String = ""
    var lastName: String = ""
    var phone: String = ""
    var email: String = ""
    var password: String = ""
    var termsOfUse: Bool = false
    var privacyPolicy: Bool = false
}

extension UserRegisterModel: ValidationType {
    var validator: Validator {
        return UserRegisterValidator(self)
    }
}

extension UserRegisterModel {
    func registerRequest() -> RegisterRequestModel {
        return RegisterRequestModel(email: email, lastName: lastName, firstName: name, birthDate: nil, specialization: nil, phoneNumber: phone, password: password)
    }
}

