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
    case serverNotResponding
}

extension Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .objectMapping: return "Ошибка чтения данных"
        case .serverNotResponding: return "Сервер не отвечает, попробуйте позже"
        default: return nil
        }
    }
}

struct RawStringError: Error, LocalizedError {
    let value: String
    
    var errorDescription: String? {
        return value
    }
}
