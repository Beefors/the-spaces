//
//  FiltersRadioButtonUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

class FiltersRadioButtonUIBuilder: ServiceType {
    typealias Owner = FiltersRadioButtonViewController

    unowned(unsafe) let owner: FiltersRadioButtonViewController
    
    required init(owner: FiltersRadioButtonViewController) {
        self.owner = owner
    }
    
    func setup() {
        
        owner.title = owner.beheviorService.viewModel.title
        
        owner.resetButton.setTitle("Сбросить фильтры", for: .normal)
        owner.resetButton.titleLabel?.font = .choiceGray
        owner.resetButton.setTitleColor(.STChoiceGray, for: .normal)
        
        owner.applyButton.setTitle("Применить", for: .normal)
        owner.applyButton.backgroundColor = .STBlue
        owner.applyButton.layer.cornerRadius = owner.applyButton.bounds.height / 2
        owner.applyButton.titleLabel?.font = .registerButton
        owner.applyButton.setTitleColor(.white, for: .normal)
        
        owner.tableView.contentInset.top = 15
        owner.tableView.separatorColor = .clear
        
    }
    
    
    
}
