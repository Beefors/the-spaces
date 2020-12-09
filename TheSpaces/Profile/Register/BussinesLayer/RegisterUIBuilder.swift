//
//  RegisterUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 29.11.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class RegisterUIBuilder: ServiceType, UIBuilderType {
    
    //MARK: Owner type
    typealias Owner = RegisterBehaviorService.Owner
    
    //MARK: - Properties
    unowned(unsafe) let owner: RegisterBehaviorService.Owner
    
    //MARK: - Initialization
    required init(owner: RegisterBehaviorService.Owner) {
        self.owner = owner
    }
    
    //MARK: - Helpers
    func setup() {
        buildUI()
    }
    
    func buildUI() {
        owner.scrollView.contentInset.top = -(owner.navigationController?.navigationBar.bounds.height ?? 0)
        owner.scrollView.scrollIndicatorInsets.top = owner.scrollView.contentInset.top
        
        for tfContainer in textFieldsContainers() {
            tfContainer.layer.cornerRadius = tfContainer.bounds.height / 2
            tfContainer.layer.borderWidth = 1
            borderFor(textFieldContainer: tfContainer, style: .normal)
        }
        
        owner.regButton.layer.cornerRadius = owner.regButton.bounds.height / 2
        owner.regButton.layer.borderWidth = 1
        owner.regButton.layer.borderColor = UIColor.STGreen.cgColor
        owner.regButton.titleLabel?.font = .registerButton
        owner.regButton.setTitleColor(.black, for: .normal)
        
        for checkButton in [owner.termsOfUseCheckButton, owner.privacyPolicyCheckButton] as [CheckButton] {
            checkButton.label.numberOfLines = 0
            checkButton.label.font = UIFont.mainText
            checkButton.checkView.tintColor = .STGreen
        }
        
        owner.termsOfUseCheckButton.label.text = "Я прочитал и соглашаюсь с условиями использования"
        owner.privacyPolicyCheckButton.label.text = "Я прочитал и соглашаюсь с политкой конфиденциальности"
        
    }
    
    func textFieldsContainers() -> Array<UIView> {
        return [
            owner.nameTextFieldContainer,
            owner.lastnameTextFieldContainer,
            owner.phoneTextFieldContainer,
            owner.emailTextFieldContainer,
            owner.passwordTextFieldContainer
        ]
    }
    
    func textFileds() -> Array<UITextField> {
        return [
            owner.nameTextField,
            owner.lastnameTextField,
            owner.phoneTextField,
            owner.emailTextField,
            owner.passwordTextField
        ]
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
    
    func showAlert(title: String, action: (() -> ())?) {
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: {_ in action?()})
        alertController.addAction(action)
        alertController.view.tintColor = UIColor.STGreen
        owner.present(alertController, animated: true, completion: nil)
    }
    
}
