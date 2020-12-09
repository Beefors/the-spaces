//
//  RegisterBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 29.11.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxKeyboard

class RegisterBehaviorService: NSObject, ServiceType {
    typealias Owner = RegisterViewController
    
    unowned(unsafe) let owner: RegisterViewController
    
    lazy var builderUI = RegisterUIBuilder(owner: owner)
    let viewModel = RegisterViewModel()
    
    required init(owner: RegisterViewController) {
        self.owner = owner
    }
    
    func setup() {
        builderUI.buildUI()
        setupObservers()
        setupTextFields()
    }
    
    func setupObservers() {
        
        //MARK: Setup keyboard observable
        viewModel.registerTrigger
            .subscribeNext(weak: owner.view) { (view) -> ((Void)) -> Void in
                view.endEditing(true)
                return {_ in }
            }
            .disposed(by: viewModel)
        
        RxKeyboard.instance
            .visibleHeight
            .drive {[unowned self] (keyboardHeight) in
                let height: CGFloat
                
                if keyboardHeight > 0 {
                    height = (keyboardHeight + self.owner.scrollView.contentInset.top) - UIApplication.shared.statusBarFrame.height
                } else {
                    height = 0
                }
                
                self.owner.scrollView.contentInset.bottom = height
                self.owner.scrollView.scrollIndicatorInsets.bottom = height
            }
            .disposed(by: viewModel)
        
        //MARK: Setup check buttons
        viewModel.termsOfUseObservable
            .bind(to: owner.termsOfUseCheckButton.rx.isSelected)
            .disposed(by: viewModel)
        
        viewModel.privacyPolicyObservable
            .bind(to: owner.privacyPolicyCheckButton.rx.isSelected)
            .disposed(by: viewModel)
        
        let termsOfUseCheckButtonRecognizer = UITapGestureRecognizer()
        owner.termsOfUseCheckButton.addGestureRecognizer(termsOfUseCheckButtonRecognizer)
        
        let privacyPolicyCheckButtonRecognizer = UITapGestureRecognizer()
        owner.privacyPolicyCheckButton.addGestureRecognizer(privacyPolicyCheckButtonRecognizer)
        
        termsOfUseCheckButtonRecognizer.rx
            .event
            .subscribe {[unowned self] (recognizer) in
                self.viewModel.termsOfUseObservable.accept(!self.viewModel.termsOfUseObservable.value)
            }
            .disposed(by: viewModel)
        
        privacyPolicyCheckButtonRecognizer.rx
            .event
            .subscribe {[unowned self] (recognizer) in
                self.viewModel.privacyPolicyObservable.accept(!self.viewModel.privacyPolicyObservable.value)
            }
            .disposed(by: viewModel)
        
        //MARK: Setup reg button
        owner.regButton.rx
            .tap
            .bind(to: viewModel.registerTrigger)
            .disposed(by: viewModel)
        
        //MARK: Setup error obaserver
        viewModel.errorObservable
            .subscribe(onNext: {[unowned self] (error) in
                
                var action: (() -> ())?
                
                if let registerDataError = error as? UserRegisterValidator.RegisterFillDataErrors {
                    
                    let tfContainer: UIView
                    let textField: UITextField
                    
                    switch registerDataError {
                    case .firstnameIsInvalid:
                        tfContainer = owner.nameTextFieldContainer
                        textField = owner.nameTextField
                    case .lastnameIsInvalid:
                        tfContainer = owner.lastnameTextFieldContainer
                        textField = owner.lastnameTextField
                    case .phoneIsInvalid:
                        tfContainer = owner.phoneTextFieldContainer
                        textField = owner.phoneTextField
                    case .emailIsInvalid:
                        tfContainer = owner.emailTextFieldContainer
                        textField = owner.emailTextField
                    case .passwordIsInvalid:
                        tfContainer = owner.passwordTextFieldContainer
                        textField = owner.passwordTextField
                    }
                    
                    action = { textField.becomeFirstResponder() }
                    self.builderUI.borderFor(textFieldContainer: tfContainer, style: .red)
                }
                
                self.builderUI.showAlert(title: error.localizedDescription, action: action)
            })
            .disposed(by: viewModel)
        
    }
    
    func setupTextFields() {
        
        for tf in builderUI.textFileds() {
            tf.delegate = self
        }
        
        owner
            .nameTextField.rx
            .text
            .filterNil()
            .skip(1)
            .bind(to: viewModel.nameObservable)
            .disposed(by: viewModel)
        
        owner
            .lastnameTextField.rx
            .text
            .filterNil()
            .skip(1)
            .bind(to: viewModel.lastNameObservable)
            .disposed(by: viewModel)
        
        owner
            .emailTextField.rx
            .text
            .filterNil()
            .skip(1)
            .bind(to: viewModel.emailObservable)
            .disposed(by: viewModel)
        
        owner
            .passwordTextField.rx
            .text
            .filterNil()
            .skip(1)
            .bind(to: viewModel.passwordObservable)
            .disposed(by: viewModel)
        
    }
    
}

extension RegisterBehaviorService: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let container = textField.superview {
            builderUI.borderFor(textFieldContainer: container, style: .normal)
        }
        
        guard textField == owner.phoneTextField else { return true }
        var number = string.filteredDecimalDigit()
        
        if number.count > 1 && (number.hasPrefix("7") || number.hasPrefix("8")) {
            number.removeFirst()
        }
        
        let result = viewModel.phoneFormatter.formatInput(currentText: textField.text ?? "", range: range, replacementString: number)
        textField.text = result.formattedText
        viewModel.phoneObservable.accept(result.formattedText)
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let index = builderUI.textFileds().firstIndex(of: textField) else { return false }
        
        if index == builderUI.textFileds().count - 1 {
            viewModel.registerTrigger.accept(())
        } else {
            builderUI.textFileds()[index + 1].becomeFirstResponder()
        }
        
        return true
    }
    
}
