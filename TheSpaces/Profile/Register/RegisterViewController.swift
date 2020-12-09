//
//  RegisterViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 29.11.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameTextFieldContainer: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextFieldContainer: UIView!
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var phoneTextFieldContainer: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextFieldContainer: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextFieldContainer: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var regButton: UIButton!
    
    @IBOutlet weak var termsOfUseCheckButton: CheckButton!
    @IBOutlet weak var privacyPolicyCheckButton: CheckButton!
    
    //MARK: - Services
    lazy var behaviorService = RegisterBehaviorService(owner: self)
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        behaviorService.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
