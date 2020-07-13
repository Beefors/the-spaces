//
//  Errors.swift
//  TheSpaces
//
//  Created by Денис Швыров on 12.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

enum Errors: Error {
    case objectMapping
}

extension Errors: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .objectMapping: return "Ошибка чтения данных"
        default: return nil
        }
        
    }
    
}
