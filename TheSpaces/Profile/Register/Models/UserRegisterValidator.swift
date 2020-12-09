//
//  UserRegisterValidator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

class UserRegisterValidator: NSObject, RulesValidator {
    
    enum RegisterFillDataErrors: Error {
        case firstnameIsInvalid(error: FirstnameRegisterValidationRule.FirstnameRegisterValidationError)
        case lastnameIsInvalid(error: LastnameRegisterValidationRule.LastnameRegisterValidationError)
        case phoneIsInvalid(error: PhoneRegisterValidationRule.PhoneRegisterValidationError)
        case emailIsInvalid(error: EmailRegisterValidationRule.EmailRegisterValidationError)
        case passwordIsInvalid(error: PasswordRegisterValidationRule.PasswordRegisterValidationError)
    }
    
    let model: UserRegisterModel
    
    required init(_ model: UserRegisterModel) {
        self.model = model
    }
    
    var validation: ValidationType {
        model
    }
    
    var rules: Array<ValidationRule> = [
        FirstnameRegisterValidationRule(),
        LastnameRegisterValidationRule(),
        PhoneRegisterValidationRule(),
        EmailRegisterValidationRule(),
        PasswordRegisterValidationRule(),
        TermsRegisterValidationRule(),
        PrivacyRegisterValidationRule()
    ]
}

extension UserRegisterValidator.RegisterFillDataErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .firstnameIsInvalid(let error): return error.localizedDescription
        case .lastnameIsInvalid(let error): return error.localizedDescription
        case .phoneIsInvalid(let error): return error.localizedDescription
        case .emailIsInvalid(let error): return error.localizedDescription
        case .passwordIsInvalid(let error): return error.localizedDescription
        }
    }
}

//MARK: - Register rules

class RegisterValidationRule {
    enum RegisterValidationRuleError: Error {
        case unavalibleType
    }
    
    func validate(model: UserRegisterModel) throws {}
}

extension RegisterValidationRule : ValidationRule {
    func validate(_ validation: ValidationType) throws {
        guard let model = validation as? UserRegisterModel else { throw RegisterValidationRuleError.unavalibleType }
        try validate(model: model)
    }
}

class FirstnameRegisterValidationRule: RegisterValidationRule {
    
    let minCharCount = 3
    
    typealias RegisterFillDataErrors = UserRegisterValidator.RegisterFillDataErrors
    enum FirstnameRegisterValidationError: Error {
        case isEmpty
        case short
    }
    
    override func validate(model: UserRegisterModel) throws {
        try super.validate(model: model)
        let firstname = model.name
        
        guard firstname.isNotEmpty else { throw RegisterFillDataErrors.firstnameIsInvalid(error: .isEmpty) }
        guard firstname.count >= minCharCount else { throw RegisterFillDataErrors.firstnameIsInvalid(error: .short) }
        
    }
}

extension FirstnameRegisterValidationRule.FirstnameRegisterValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .isEmpty: return "Укажите свое имя"
        case .short: return "Имя слишком короткое"
        }
    }
}

class LastnameRegisterValidationRule: RegisterValidationRule {
    
    let minCharCount = 3
    
    typealias RegisterFillDataErrors = UserRegisterValidator.RegisterFillDataErrors
    enum LastnameRegisterValidationError: Error {
        case isEmpty
        case short
    }
    
    override func validate(model: UserRegisterModel) throws {
        try super.validate(model: model)
        let lastName = model.lastName
        
        guard lastName.isNotEmpty else { throw RegisterFillDataErrors.lastnameIsInvalid(error: .isEmpty) }
        guard lastName.count >= minCharCount else { throw RegisterFillDataErrors.lastnameIsInvalid(error: .short) }
    }
}

extension LastnameRegisterValidationRule.LastnameRegisterValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .isEmpty: return "Укажите свою фамилию"
        case .short: return "Фамилия слишком короткая"
        }
    }
}

class PhoneRegisterValidationRule: RegisterValidationRule {
    let phoneLenth = 11
    
    typealias RegisterFillDataErrors = UserRegisterValidator.RegisterFillDataErrors
    enum PhoneRegisterValidationError: Error {
        case isEmpty
        case notCorrect
    }
    
    override func validate(model: UserRegisterModel) throws {
        try super.validate(model: model)
        let phone = model.phone
        
        guard phone.isNotEmpty else { throw RegisterFillDataErrors.phoneIsInvalid(error: .isEmpty) }
        guard phone.filteredDecimalDigit().count == phoneLenth else { throw RegisterFillDataErrors.phoneIsInvalid(error: .notCorrect) }
    }
    
}

extension PhoneRegisterValidationRule.PhoneRegisterValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .isEmpty: return "Укажите номер телефона"
        case .notCorrect: return "Номер телефона некорректен"
        }
    }
}

class EmailRegisterValidationRule: RegisterValidationRule {
    
    typealias RegisterFillDataErrors = UserRegisterValidator.RegisterFillDataErrors
    enum EmailRegisterValidationError: Error {
        case isEmpty
        case notCorrect
    }
    
    override func validate(model: UserRegisterModel) throws {
        try super.validate(model: model)
        let email = model.email
        
        guard email.isNotEmpty else { throw RegisterFillDataErrors.emailIsInvalid(error: .isEmpty) }
        guard email.isValidEmail() else { throw RegisterFillDataErrors.emailIsInvalid(error: .notCorrect) }
    }
    
}

extension EmailRegisterValidationRule.EmailRegisterValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .isEmpty: return "Укажите свой Email"
        case .notCorrect: return "Email некорректен"
        }
    }
}

class PasswordRegisterValidationRule: RegisterValidationRule {
    let minLenth = 6
    
    typealias RegisterFillDataErrors = UserRegisterValidator.RegisterFillDataErrors
    enum PasswordRegisterValidationError: Error {
        case isEmpty
        case short
    }
    
    override func validate(model: UserRegisterModel) throws {
        try super.validate(model: model)
        let password = model.password
        
        guard password.isNotEmpty else { throw RegisterFillDataErrors.passwordIsInvalid(error: .isEmpty) }
        guard password.count >= minLenth else { throw RegisterFillDataErrors.passwordIsInvalid(error: .short) }
    }
    
}

extension PasswordRegisterValidationRule.PasswordRegisterValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .isEmpty: return "Придумайте пароль"
        case .short: return "Пароль должен содержать минимум 6 символов"
        }
    }
}

class TermsRegisterValidationRule: RegisterValidationRule {
    
    typealias RegisterFillDataErrors = UserRegisterValidator.RegisterFillDataErrors
    enum TermsRegisterValidationError: Error {
        case notAccepted
    }
    
    override func validate(model: UserRegisterModel) throws {
        try super.validate(model: model)
        let termsOfUse = model.termsOfUse
        
        guard termsOfUse else { throw TermsRegisterValidationError.notAccepted }
    }
    
}

extension TermsRegisterValidationRule.TermsRegisterValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notAccepted: return "Необходимо согласиться с условиями использования"
        }
    }
}

class PrivacyRegisterValidationRule: RegisterValidationRule {
    
    typealias RegisterFillDataErrors = UserRegisterValidator.RegisterFillDataErrors
    enum PrivacyRegisterValidationError: Error {
        case notAccepted
    }
    
    override func validate(model: UserRegisterModel) throws {
        try super.validate(model: model)
        let privacyPolicy = model.privacyPolicy
        
        guard privacyPolicy else { throw PrivacyRegisterValidationError.notAccepted }
    }
    
}

extension PrivacyRegisterValidationRule.PrivacyRegisterValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notAccepted: return "Необходимо согласиться с политикой конфиденциальности"
        }
    }
}
