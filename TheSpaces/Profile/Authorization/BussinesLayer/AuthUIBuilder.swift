//
//  AuthUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 21.10.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class AuthuiBuilder: ServiceType, UIBuilderType {
    
    //MARK: Owner type
    typealias Owner = AuthBehaviorService.Owner
    
    //MARK: - Properties
    unowned(unsafe) let owner: AuthBehaviorService.Owner
    
    //MARK: - Initialization
    required init(owner: AuthBehaviorService.Owner) {
        self.owner = owner
    }
    
    //MARK: - Help methods
    func setup() {
        buildUI()
    }
    
    func buildUI() {
        
        // Setup login text field
        let loginTFContainer = owner.loginTextField.superview
        
        loginTFContainer?.layer.cornerRadius = (loginTFContainer?.bounds.height ?? 0) / 2
        loginTFContainer?.layer.borderWidth = 1
        loginTFContainer?.layer.borderColor = UIColor.STGrayUnderline.cgColor
        
        // Setup password text field
        let passwordTFContainer = owner.passwordTextField.superview
        
        passwordTFContainer?.layer.cornerRadius = (passwordTFContainer?.bounds.height ?? 0) / 2
        passwordTFContainer?.layer.borderWidth = 1
        passwordTFContainer?.layer.borderColor = UIColor.STGrayUnderline.cgColor
        
        // Setup login button
        owner.loginButton.layer.cornerRadius = owner.loginButton.bounds.height / 2
        owner.loginButton.backgroundColor = .STGreen
        owner.loginButton.setTitleColor(.white, for: .normal)
        owner.loginButton.titleLabel?.font = .registerButton
        
        // Setup register button
        owner.registerButton.layer.cornerRadius = owner.registerButton.bounds.height / 2
        owner.registerButton.layer.borderWidth = 1
        owner.registerButton.layer.borderColor = UIColor.STGreen.cgColor
        owner.registerButton.titleLabel?.font = .registerButton
        owner.registerButton.setTitleColor(.black, for: .normal)
        
        // Setup refresh password button
        owner.refreshButton.setTitleColor(.STGrayUnderline, for: .normal)
        
        let attrString = NSAttributedString(string: owner.refreshButton.titleLabel?.text ?? "", attributes: [.font: UIFont.underline, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.STGrayUnderline])
        
        owner.refreshButton.titleLabel?.attributedText = attrString

        // Setup error label
        owner.errorLabel.attributedText = NSAttributedString(string: owner.errorLabel.text ?? "", attributes: [.font: UIFont.underline, .foregroundColor: UIColor.STRed, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.STRed])
        
        hideError()
        
    }
    
    func showError() {
        owner.errorLabel.alpha = 1
    }
    
    func hideError() {
        owner.errorLabel.alpha = 0
    }
    
}
