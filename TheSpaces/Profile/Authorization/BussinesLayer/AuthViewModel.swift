//
//  AuthViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 29.11.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ProgressHUD

class AuthViewModel: ViewModelType {
    
    //MARK: View model
    let bag = DisposeBag()
    
    //MARK: - Observables
    let loginObservable = BehaviorRelay<String>(value: "")
    let passObservable = BehaviorRelay<String>(value: "")
    
    let authTrigger = PublishRelay<Void>()
    
    let errorObservable = PublishRelay<Error>()
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        
        let authViewModel = TabBarSource.shared.profileNavController.behaviorService.viewModel
        setupAuthTrigger(authViewModel: authViewModel)
        
        authViewModel
            .errorObservables
            .bind(to: errorObservable)
            .disposed(by: bag)
        
    }
    
    private func setupAuthTrigger(authViewModel: UserViewModel) {
        authTrigger
            .map {[unowned self] in
                UserAuthModel(email: self.loginObservable.value, pass: self.passObservable.value)
            }
            .validate()
            .subscribe(onNext: {[unowned authViewModel] (auth) in
                authViewModel.loginTrigger.accept(auth)
            }, onError: {[unowned self, unowned authViewModel] (error) in
                self.errorObservable.accept(error)
                self.setupAuthTrigger(authViewModel: authViewModel)
            })
            .disposed(by: bag)
    }
    
}
