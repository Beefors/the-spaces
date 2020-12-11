//
//  ConfirmCodeBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxKeyboard

class ConfirmCodeBehaviorService: NSObject, ServiceType {
    typealias Owner = ConfirmCodeViewController
    unowned(unsafe) let owner: ConfirmCodeViewController
    
    lazy var buiderUI = ConfirmCodeUIBuilder(owner: owner)
    let viewModel = ConfirmCodeViewModel()
    
    required init(owner: ConfirmCodeViewController) {
        self.owner = owner
    }
    
    func setup() {
        buiderUI.buildUI()
        
        setupObservers()
    }
    
    private func setupObservers() {
        
        //MARK: Setup keyboard observable
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
        
        viewModel.confirmTrigger
            .subscribeNext(weak: owner.view) { (view) -> ((Void)) -> Void in
                view.endEditing(true)
                return {_ in}
            }
            .disposed(by: viewModel)
        
        //MARK: Text field observable
        owner.codeTextField.rx
            .text
            .filterNil()
            .distinctUntilChanged()
            .do(onNext: {[unowned self] (_) in
                self.buiderUI.hideError()
                self.buiderUI.borderFor(textFieldContainer: self.owner.codeTextFieldContainer, style: .normal)
            })
            .bind(to: viewModel.codeObservable)
            .disposed(by: viewModel)
        
        //MARK: Setup confirm button
        owner.confirmButton.rx
            .tap
            .bind(to: viewModel.confirmTrigger)
            .disposed(by: viewModel)
        
        //MARK: Setup error observable
        viewModel.errorObservable
            .subscribe (onNext: {[unowned self] (error) in
                
                self.buiderUI.showError(text: error.localizedDescription)
                
                switch error {
                case is CodeValidator.Errors: self.buiderUI.borderFor(textFieldContainer: self.owner.codeTextFieldContainer, style: .red)
                default: break
                }
            })
            .disposed(by: viewModel)
        
    }
    
}
