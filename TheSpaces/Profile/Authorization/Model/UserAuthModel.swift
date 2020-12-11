//
//  UserAuthModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

struct UserAuthModel: ValidationType {
    
    let email: String
    let pass: String
    
    init(email: String, pass: String) {
        self.email = email
        self.pass = pass
    }
    
    init(registerModel: UserRegisterModel) {
        self.init(email: registerModel.email, pass: registerModel.password)
    }
    
    var validator: Validator {
        return AuthValidator(authModel: self)
    }
}
