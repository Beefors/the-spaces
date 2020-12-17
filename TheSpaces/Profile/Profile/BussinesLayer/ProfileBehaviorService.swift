//
//  ProfileBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxKeyboard

class ProfileBehaviorService: NSObject, ServiceType {
    
    //MARK: Owner type
    typealias Owner = ProfileViewController

    //MARK: - Properties
    unowned(unsafe) let owner: ProfileViewController
    let viewModel = ProfileViewModel()
    
    //MARK: - Services
    lazy var builderUI = ProfileUIBuilder(owner: owner)
    
    //MARK: - Initialization
    required init(owner: ProfileViewController) {
        self.owner = owner
    }
    
    //MARK: - Helpers
    func setup() {
        
        //MARK: Setup UI
        builderUI.buildUI()
        
        // Setup text fields
        for tf in builderUI.textFields() {
            tf.delegate = self
            tf.returnKeyType = .send
        }
        
        //MARK: Setup user data observable
        TabBarSource.shared
            .profileNavController
            .behaviorService
            .viewModel
            .userObservable
            .filterNil()
            .subscribeNext(weak: owner) { (owner) -> (UserDataModel) -> Void in
                return { userData in
                    owner.fioLabel.text = userData.lastName + " " + userData.firstName
                    owner.fioTextField.text = owner.fioLabel.text
                    owner.birthdayTextField.text = ""
                    owner.emailTextField.text = userData.email
                    owner.phoneTextField.text = ""
                    owner.specializationTextField.text = ""
                }
            }
            .disposed(by: viewModel)
        
        //MARK: Setup keyboard observable
        RxKeyboard.instance
            .visibleHeight
            .drive {[unowned self] (keyboardHeight) in
                let height: CGFloat
                
                if keyboardHeight > 0 {
                    height = keyboardHeight - (self.owner.navigationController!.navigationBar.bounds.height + UIApplication.shared.statusBarFrame.height)
                } else {
                    height = 0
                }
                
                self.owner.scrollView.contentInset.bottom = height
                self.owner.scrollView.scrollIndicatorInsets.bottom = height
            }
            .disposed(by: viewModel)
        
        //MARK: State observables
        viewModel.stateObservable
            .map({
                switch $0 {
                case .normal: return "Изменить"
                case .editing: return "Сохранить"
                }
            })
            .subscribeNext(weak: builderUI, { (builderUI) -> (String) -> Void in
                return { title in
                    builderUI.setChangeButtonTitle(title)
                }
            })
            .disposed(by: viewModel)
        
        owner.changeButton.rx
            .tap
            .bind(to: viewModel.togleStateTrigger)
            .disposed(by: viewModel)
        
        viewModel.stateObservable
            .skip(1)
            .filter({ $0 == .normal })
            .mapTo(())
            .subscribeNext(weak: self) { (behaviorService) -> (()) -> Void in
                behaviorService.owner.view.endEditing(true)
                return { _ in }
            }
            .disposed(by: viewModel)
        
        //MARK: Setup back bar item
        let backItem = UIBarButtonItem(image: #imageLiteral(resourceName: "authBackIndicator").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        owner.navigationItem.leftBarButtonItem = backItem
        
        backItem.rx
            .tap
            .subscribeNext(weak: self, { (behaviorService) -> (()) -> Void in
                let alert = UIAlertController(title: nil, message: "Выйти из аккаунта?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Да", style: .default) { (_) in
                    TabBarSource.shared.profileNavController.behaviorService.viewModel.logoutTrigger.accept(())
                }
                
                let noAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                alert.view.tintColor = UIColor.STGreen
                
                behaviorService.owner.present(alert, animated: true, completion: nil)
                
                return { _ in }
            })
            .disposed(by: viewModel)
        
    }
    
}

extension ProfileBehaviorService: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewModel.stateObservable.value != .normal
    }
}

