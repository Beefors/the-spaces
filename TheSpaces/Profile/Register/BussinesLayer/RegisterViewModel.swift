//
//  RegisterViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 30.11.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AnyFormatKit
import ProgressHUD

class RegisterViewModel: ViewModelType {
    
    //MARK: ViewModel
    let bag = DisposeBag()
    
    //MARK: - Properties
    lazy var phoneFormatter = DefaultTextInputFormatter(textPattern: "+\(countryCode) (###) ### ##-##")
    let countryCode = "7"
    
    //MARK: - Observables
    let nameObservable = BehaviorRelay<String>(value: "")
    let lastNameObservable = BehaviorRelay<String>(value: "")
    let phoneObservable = BehaviorRelay<String>(value: "")
    let emailObservable = BehaviorRelay<String>(value: "")
    let passwordObservable = BehaviorRelay<String>(value: "")
    let termsOfUseObservable = BehaviorRelay<Bool>(value: true)
    let privacyPolicyObservable = BehaviorRelay<Bool>(value: false)
    let userModelObservable = BehaviorRelay<UserRegisterModel>(value: UserRegisterModel())
    
    let registerTrigger = PublishRelay<(Void)>()
    let errorObservable = PublishRelay<Error>()
    
    //MARK: - Initialization
    init() {
        registerDataObservers()
        registerObservers()
    }
    
    //MARK: - Helpers
    func formattedPhone(number: String) -> String {
        var number = number
        if number.count > 1 { number.removeFirst() }
        return phoneFormatter.format(number) ?? ""
    }
    
    private func registerDataObservers() {
        nameObservable
            .map({[unowned self] (value) in
                return (self.userModelObservable.value, value)
            })
            .filter({(userModel, value) -> Bool in
                userModel.name != value
            })
            .map({ (userModel, value) in
                var model = userModel
                model.name = value
                return model
            })
            .bind(to: userModelObservable)
            .disposed(by: bag)
        
        lastNameObservable
            .map({[unowned self] (value) in
                return (self.userModelObservable.value, value)
            })
            .filter({(userModel, value) -> Bool in
                userModel.lastName != value
            })
            .map({ (userModel, value) in
                var model = userModel
                model.lastName = value
                return model
            })
            .bind(to: userModelObservable)
            .disposed(by: bag)
        
        phoneObservable
            .map({[unowned self] (value) in
                return (self.userModelObservable.value, value)
            })
            .filter({(userModel, value) -> Bool in
                userModel.phone != value
            })
            .map({ (userModel, value) in
                var model = userModel
                model.phone = value
                return model
            })
            .bind(to: userModelObservable)
            .disposed(by: bag)
        
        emailObservable
            .map({[unowned self] (value) in
                return (self.userModelObservable.value, value)
            })
            .filter({(userModel, value) -> Bool in
                userModel.email != value
            })
            .map({ (userModel, value) in
                var model = userModel
                model.email = value
                return model
            })
            .bind(to: userModelObservable)
            .disposed(by: bag)
        
        passwordObservable
            .map({[unowned self] (value) in
                return (self.userModelObservable.value, value)
            })
            .filter({(userModel, value) -> Bool in
                userModel.password != value
            })
            .map({ (userModel, value) in
                var model = userModel
                model.password = value
                return model
            })
            .bind(to: userModelObservable)
            .disposed(by: bag)
        
        termsOfUseObservable
            .map({[unowned self] (value) in
                return (self.userModelObservable.value, value)
            })
            .filter({(userModel, value) -> Bool in
                userModel.termsOfUse != value
            })
            .map({ (userModel, value) in
                var model = userModel
                model.termsOfUse = value
                return model
            })
            .bind(to: userModelObservable)
            .disposed(by: bag)
        
        privacyPolicyObservable
            .map({[unowned self] (value) in
                return (self.userModelObservable.value, value)
            })
            .filter({(userModel, value) -> Bool in
                userModel.privacyPolicy != value
            })
            .map({ (userModel, value) in
                var model = userModel
                model.privacyPolicy = value
                return model
            })
            .bind(to: userModelObservable)
            .disposed(by: bag)
        
    }
    
    private func registerObservers() {
        registerTrigger
            .map {[unowned self] in
                self.userModelObservable.value
            }
            .validate()
            .do(onNext: { _ in
                ProgressHUD.show(nil, interaction: false)
            })
            .flatMap({ NetworkService.shared.register(request: $0.registerRequest()) })
            .subscribe { (user) in
                ProgressHUD.dismiss()
            } onError: {[unowned self] (error) in
                ProgressHUD.dismiss()
                self.errorObservable.accept(error)
                self.registerObservers()
            }
            .disposed(by: bag)
    }
    
}
