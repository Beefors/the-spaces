//
//  ViewModelType.swift
//  TheSpaces
//
//  Created by Денис Швыров on 27.01.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift

protocol ViewModelType {
    var bag: DisposeBag { get }
}

extension Disposable {
    func disposed(by viewModel: ViewModelType) {
        disposed(by: viewModel.bag)
    }
}
