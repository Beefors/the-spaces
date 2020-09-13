//
//  FiltersUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 26.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FiltersUIBuilder: ServiceType {
    typealias Owner = FiltersViewController
    
    //MARK: Owner
    unowned(unsafe) let owner: FiltersViewController
    
    //MARK: - Views
    let closeItem = UIBarButtonItem(image: UIImage(named: "closeButtonIcon")!, style: .plain, target: nil, action: nil)
    
    //MARK: - Initialization
    required init(owner: FiltersViewController) {
        self.owner = owner
    }
    
    //MARK: - Setups
    func setup() {
        owner.title = "Отфильтровать"
        owner.navigationItem.leftBarButtonItem = closeItem
        closeItem.tintColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1)
        
        owner.resetFiltersButton.setTitle("Сбросить фильтры", for: .normal)
        owner.resetFiltersButton.titleLabel?.font = .choiceGray
        owner.resetFiltersButton.setTitleColor(.STChoiceGray, for: .normal)
        
        owner.applyFiltersButton.backgroundColor = .STBlue
        owner.applyFiltersButton.layer.cornerRadius = owner.applyFiltersButton.bounds.height / 2
        owner.applyFiltersButton.titleLabel?.font = .registerButton
        owner.applyFiltersButton.setTitleColor(.white, for: .normal)
    }
    
    func setupPlacesCount(_ count: Int) {
        owner.applyFiltersButton.setTitle("Показать \(count) мест", for: .normal)
    }
    
}

extension Reactive where Base == FiltersUIBuilder {
    var placesCount: Binder<Int> {
        return Binder<Int>(base) { (service, placesCount) in
            service.setupPlacesCount(placesCount)
        }
    }
}
