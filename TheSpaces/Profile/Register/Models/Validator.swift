//
//  Validator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift

protocol Validator {
    func validate() throws
}

extension Validator {
    func isValid() -> Bool {
        return (try? validate()) != nil
    }
}

protocol ValidationRule {
    func validate(_ validation: ValidationType) throws
}

protocol RulesValidator: Validator {
    var validation: ValidationType {get}
    var rules: Array<ValidationRule> {get set}
}

extension RulesValidator {
    func validate() throws {
        for rule in rules {
            try rule.validate(validation)
        }
    }
}

protocol ValidationType {
    var validator: Validator {get}
}

extension ObservableType where Element: Validator {
    func validate() -> RxSwift.Observable<Self.Element> {
        `do` { (validator) in
            try validator.validate()
        }
    }
}

extension ObservableType where Element: ValidationType {
    func validate() -> RxSwift.Observable<Self.Element> {
        `do` { (validationType) in
            try validationType.validator.validate()
        }
    }
}
