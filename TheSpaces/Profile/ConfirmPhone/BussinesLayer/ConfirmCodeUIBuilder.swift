//
//  ConfirmCodeUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class ConfirmCodeUIBuilder: ServiceType, UIBuilderType {
    typealias Owner = ConfirmCodeBehaviorService.Owner
    
    unowned(unsafe) let owner: ConfirmCodeBehaviorService.Owner
    
    required init(owner: ConfirmCodeBehaviorService.Owner) {
        self.owner = owner
    }
    
    func setup() {
        buildUI()
    }
    
    func buildUI() {
        
        // Setup scroll view top insets
        owner.scrollView.contentInset.top = -(owner.navigationController?.navigationBar.bounds.height ?? 0)
        owner.scrollView.scrollIndicatorInsets.top = owner.scrollView.contentInset.top
        
        // Setup code text field
        owner.codeTextFieldContainer.layer.cornerRadius = owner.codeTextFieldContainer.bounds.height / 2
        owner.codeTextFieldContainer.layer.borderWidth = 1
        borderFor(textFieldContainer: owner.codeTextFieldContainer, style: .normal)
        
        // Setup login button
        owner.confirmButton.layer.cornerRadius = owner.confirmButton.bounds.height / 2
        owner.confirmButton.backgroundColor = .STGreen
        owner.confirmButton.setTitleColor(.white, for: .normal)
        owner.confirmButton.titleLabel?.font = .registerButton
        
        // Setup error label
        hideError()
        
    }
    
    func showError(text: String) {
        owner.errorLabel.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.underline, .foregroundColor: UIColor.STRed, .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.STRed])
        owner.errorLabel.alpha = 1
    }
    
    func hideError() {
        owner.errorLabel.text = ""
        owner.errorLabel.alpha = 0
    }
    
    enum TFBorderStyle {
        case normal
        case red
    }
    
    func borderFor(textFieldContainer: UIView, style: TFBorderStyle) {
        
        let borderColor: CGColor
        
        switch style {
        case .normal: borderColor = UIColor.STGrayUnderline.cgColor
        case .red: borderColor = UIColor.STRed.cgColor
        }
        
        textFieldContainer.layer.borderColor = borderColor
    }
    
}
