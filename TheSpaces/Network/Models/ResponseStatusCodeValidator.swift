//
//  ResponseStatusCodeValidator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import Moya

extension Response: ValidationType {
    var validator: Validator {
        ResponseStatusCodeValidator(response: self)
    }
}

class ResponseStatusCodeValidator: Validator {
    
    let value: Response
    
    init(response: Response) {
        value = response
    }
    
    func validate() throws {
        switch value.statusCode {
        case 200: return
        case 500: throw Errors.serverNotResponding
        default:
            do {
                let string = try value.mapString()
                throw RawStringError(value: string)
            } catch let e as RawStringError {
                throw e
            } catch {
                throw Errors.objectMapping
            }
        }
    }
    
}
