//
//  ProfileViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fioLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet var tfLabels: [UILabel]!
    
    @IBOutlet weak var fioTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var specializationTextField: UITextField!
    
    //MARK: - Service
    lazy var behaviorService = ProfileBehaviorService(owner: self)
    
    //MARK: - Lyfecylce
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
