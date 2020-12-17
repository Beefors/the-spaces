//
//  ConfirmCodeViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ProgressHUD

class ConfirmCodeViewModel: ViewModelType {
    
    //MARK: ViewModel
    let bag = DisposeBag()
    
    //MARK: - Properties
    var authModel: UserAuthModel!
    
    //MARK: - Observables
    let codeObservable = BehaviorRelay<String>(value: "")
    let confirmTrigger = PublishRelay<(Void)>()
    
    let successObservable = PublishRelay<Void>()
    let errorObservable = PublishRelay<Error>()
    
    //MARK: - Initialization
    init() {
        setupObservers()
        
        TabBarSource.shared
            .profileNavController
            .behaviorService
            .viewModel
            .errorObservables
            .bind(to: errorObservable)
            .disposed(by: bag)
        
    }
    
    //MARK: - Helpers
    private func setupObservers() {
        confirmTrigger
            .map({[unowned self] in
                self.codeObservable.value
            })
            .map({CodeValidationAdapter(code: $0)})
            .validate()
            .do(onNext: {_ in ProgressHUD.show(nil, interaction: false)})
            .flatMap({[unowned self] in NetworkService.shared.confirmPhone(email: self.authModel.email, code: $0.code)})
            .do(onNext: {[unowned self] in self.successObservable.accept(()) })
            .do(onNext: {[unowned self] in TabBarSource.shared.profileNavController.behaviorService.viewModel.loginTrigger.accept(self.authModel) })
            .flatMap({ TabBarSource.shared.profileNavController.behaviorService.viewModel.userObservable.filterNil().take(1) })
            .subscribe { _ in
                ProgressHUD.dismiss()
            } onError: {[unowned self] (error) in
                ProgressHUD.dismiss()
                self.errorObservable.accept(error)
                self.setupObservers()
            }
            .disposed(by: bag)
    }
    
}
