//
//  ResponsePasswordErrorChecker.swift
//  TheSpaces
//
//  Created by Денис Швыров on 15.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import Moya

class RegisterResponseErrorChecker: ResponseThrowChecker {
    
    let response: Response
    
    required init(_ response: Response) {
        self.response = response
    }
    
    func check() throws {
        try ResponseEmailErrorChecker(response).check()
        try ResponsePasswordErrorChecker(response).check()
    }
    
    
}

class ResponseEmailErrorChecker: ResponseThrowChecker {
    
    struct EmailServerError: Decodable, LocalizedError {
        let email: String
        
        var errorDescription: String? {
            return email
        }
    }
    
    let response: Response
    
    required init(_ response: Response) {
        self.response = response
    }
    
    func check() throws {
        guard let emailError = try? response.map(EmailServerError.self) else { return }
        throw emailError
    }
}

class ResponsePasswordErrorChecker: ResponseThrowChecker {
    
    struct PasswordServerError: Decodable, LocalizedError {
        let password: String
        
        var errorDescription: String? {
            return password
        }
    }
    
    let response: Response
    
    required init(_ response: Response) {
        self.response = response
    }
    
    func check() throws {
        guard let passwordError = try? response.map(PasswordServerError.self) else { return }
        throw passwordError
    }
}
