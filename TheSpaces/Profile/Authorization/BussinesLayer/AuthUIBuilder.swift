//
//  AuthUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 21.10.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class AuthuiBuilder: ServiceType, UIBuilderType, TFContainerStyler {
    
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
        owner.loginTFContainer.layer.cornerRadius = owner.loginTFContainer.bounds.height / 2
        owner.loginTFContainer.layer.borderWidth = 1
        borderFor(textFieldContainer: owner.loginTFContainer, style: .normal)
        
        // Setup password text field
        owner.passwordTFContainer.layer.cornerRadius = owner.passwordTFContainer.bounds.height / 2
        owner.passwordTFContainer.layer.borderWidth = 1
        borderFor(textFieldContainer: owner.passwordTFContainer, style: .normal)
        
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
        hideError()
        
    }
    
    func showError(text: String) {
        owner.errorLabel.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.underline, .foregroundColor: UIColor.STRed, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.STRed])
        owner.errorLabel.alpha = 1
    }
    
    func hideError() {
        owner.errorLabel.alpha = 0
    }
    
}
