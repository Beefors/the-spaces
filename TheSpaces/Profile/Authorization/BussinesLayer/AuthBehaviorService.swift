//
//  AuthBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 21.10.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxKeyboard

class AuthBehaviorService: NSObject, ServiceType {
    
    //MARK: Owner type
    typealias Owner = AuthorizationViewController

    //MARK: - Properties
    unowned(unsafe) let owner: AuthorizationViewController
    let viewModel = AuthViewModel()
    
    //MARK: - Initialization
    required init(owner: AuthorizationViewController) {
        self.owner = owner
    }
    
    //MARK: - Services
    lazy var builderUI = AuthuiBuilder(owner: owner)
    
    //MARK: - Help methods
    func setup() {
        builderUI.buildUI()
        
        owner.loginTextField.delegate = self
        owner.passwordTextField.delegate = self
        
        //MARK: Setup keyboard observable
        viewModel.authTrigger
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
                    height = (keyboardHeight - TabBarSource.shared.tabBarController.tabBar.bounds.height)
                } else {
                    height = 0
                }
                
                self.owner.scrollView.contentInset.bottom = height
                self.owner.scrollView.scrollIndicatorInsets.bottom = height
            }
            .disposed(by: viewModel)
        
        
        //MARK: Setup buttons observables
        owner
            .loginButton.rx
            .tap
            .bind(to: viewModel.authTrigger)
            .disposed(by: viewModel)
        
        owner
            .registerButton.rx
            .tap
            .map({RouterManager.Route(coordinator: ProfileCoordinator.register)})
            .bind(to: RouterManager.shared.rx.present)
            .disposed(by: viewModel)
        
        //MARK: Setup text fields observables
        owner
            .loginTextField.rx
            .text
            .filterNil()
            .bind(to: viewModel.loginObservable)
            .disposed(by: viewModel)
        
        owner
            .passwordTextField.rx
            .text
            .filterNil()
            .bind(to: viewModel.passObservable)
            .disposed(by: viewModel)
        
        //MARK: Setup error observable
        viewModel.errorObservable
            .subscribeNext(weak: self) { (behaviorService) -> (Error) -> Void in
                return { error in
                    
                    behaviorService.owner.scrollView.scrollRectToVisible(behaviorService.owner.errorLabel.frame, animated: true)
                    
                    behaviorService.builderUI.showError(text: error.localizedDescription)
                    
                    switch error {
                    case let e as AuthValidator.Erros:
                        
                        switch e {
                        case .login: behaviorService.builderUI.borderFor(textFieldContainer: behaviorService.owner.loginTFContainer, style: .red)
                        case .password: behaviorService.builderUI.borderFor(textFieldContainer: behaviorService.owner.passwordTFContainer, style: .red)
                        }
                        
                    default: break
                    }
                }
            }
            .disposed(by: viewModel)
    }
    
}

extension AuthBehaviorService: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let container: UIView
        
        switch textField {
        case owner.loginTextField:
            container = owner.loginTFContainer
        default:
            container = owner.passwordTFContainer
        }
        
        builderUI.hideError()
        builderUI.borderFor(textFieldContainer: container, style: .normal)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case owner.loginTextField:
            owner.passwordTextField.becomeFirstResponder()
        default:
            viewModel.authTrigger.accept(())
        }
        
        return false
    }
}
