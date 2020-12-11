//
//  CodeValidator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

class CodeValidator: Validator {
    
    enum Errors: Error {
        case empty
    }
    
    let codeAdapter: CodeValidationAdapter
    
    init(code: CodeValidationAdapter) {
        codeAdapter = code
    }
    
    func validate() throws {
        guard codeAdapter.code.isNotEmpty else { throw Errors.empty }
    }
    
}

extension CodeValidator.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .empty: return "Необходимо указать код"
        default: return nil
        }
    }
}
