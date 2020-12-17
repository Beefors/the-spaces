//
//  ProfileUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 17.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class ProfileUIBuilder: ServiceType, UIBuilderType {
    
    //MARK: Owner type
    typealias Owner = ProfileBehaviorService.Owner
    
    //MARK: - Properties
    unowned(unsafe) let owner: ProfileBehaviorService.Owner
    
    //MARK: - Initialization
    required init(owner: ProfileBehaviorService.Owner) {
        self.owner = owner
    }
    
    //MARK: - Helpers
    func setup() {
        buildUI()
    }
    
    func buildUI() {
        
        owner.scrollView.scrollIndicatorInsets.top = -owner.navigationController!.navigationBar.bounds.height
        
        owner.fioLabel.font = UIFont.titles
        owner.pointsLabel.font = UIFont.priceButton
        
        owner.profileTitleLabel.font = UIFont.historyNotWeight
        owner.profileTitleLabel.textColor = UIColor.STChoiceGray
        
        for tfLabel in owner.tfLabels {
            tfLabel.font = UIFont.tabbarTitles
            tfLabel.textColor = UIColor.STText
        }
        
        for tf in textFields() {
            tf.font = UIFont.subheading
            tf.textColor = UIColor.STText
            tf.tintColor = UIColor.STGreen
            tf.borderStyle = .none
        }
        
    }
    
    func textFields() -> Array<UITextField> {
        [
            owner.fioTextField,
            owner.birthdayTextField,
            owner.emailTextField,
            owner.phoneTextField,
            owner.specializationTextField
        ]
    }
    
    func setChangeButtonTitle(_ title: String) {
        let attrString = NSAttributedString(string: title, attributes: [.font: UIFont.historyNotWeight, .underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.STChoiceGray])
        owner.changeButton.setAttributedTitle(attrString, for: .normal)
    }
    
}
