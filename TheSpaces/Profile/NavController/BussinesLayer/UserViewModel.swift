//
//  UserViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel: ViewModelType {
    
    //MARK: View model
    let bag = DisposeBag()
    
    //MARK: - Triggers
    let loginTrigger = PublishRelay<UserAuthModel>()
    let logoutTrigger = PublishRelay<Void>()
    
    //MARK: - Observables
    let userObservable = BehaviorRelay<UserDataModel?>(value: UserDataFactory.loadUserData())
    let errorObservables = PublishRelay<Error>()
    
    //MARK: - Initialization
    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        setupLoginObservable()
        
        logoutTrigger
            .flatMap({ NetworkService.shared.logout() })
            .do(onNext: { UserDataFactory.removeUserData() })
            .mapTo(nil)
            .bind(to: userObservable)
            .disposed(by: bag)

    }
    
    private func setupLoginObservable() {
        loginTrigger
            .flatMap({NetworkService.shared.authorizate(email: $0.email, password: $0.pass)})
            .subscribe {[unowned self] (userData) in
                UserDataFactory.saveUserData(userData)
                self.userObservable.accept(userData)
            } onError: {[unowned self] (error) in
                self.errorObservables.accept(error)
                self.setupLoginObservable()
            }
            .disposed(by: bag)
    }
    
}
