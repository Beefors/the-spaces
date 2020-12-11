//
//  CodeValidationAdapter.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

struct CodeValidationAdapter: ValidationType {
    
    let code: String
    
    var validator: Validator {
        return CodeValidator(code: self)
    }
    
}
