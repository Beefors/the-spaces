//
//  AuthorizationViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 21.10.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    //MARK: Outlets
    // Image views
    @IBOutlet weak var authStyleImageView: UIImageView!
    @IBOutlet weak var projImageView: UIImageView!
    
    // Text fields
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    // Label
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Service
    lazy var behaviorService = AuthBehaviorService(owner: self)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        behaviorService.setup()
    }

    
    
}
