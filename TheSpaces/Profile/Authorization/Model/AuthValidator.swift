//
//  AuthValidator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

class AuthValidator: Validator {
    
    let auth: UserAuthModel
    
    init(authModel: UserAuthModel) {
        auth = authModel
    }
    
    enum Erros: Error {
        
        enum fieldError {
            case empty
            case invalid
        }
        
        case login(type: fieldError)
        case password(type: fieldError)
    }
    
    func validate() throws {
        guard auth.email.isNotEmpty else { throw Erros.login(type: .empty) }
        guard auth.email.isValidEmail() else { throw Erros.login(type: .invalid) }
        guard auth.pass.isNotEmpty else { throw Erros.password(type: .empty) }
    }
    
}

extension AuthValidator.Erros: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .login(let type):
            switch type {
            case .empty: return "Введите email"
            case .invalid: return "Некорректный email"
            }
            
        case .password(let type):
            switch type {
            case .empty: return "Введите пароль"
            case .invalid: return nil
            }
            
        }
    }
}
