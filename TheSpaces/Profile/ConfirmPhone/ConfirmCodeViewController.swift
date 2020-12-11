//
//  ConfirmCodeViewController.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit

class ConfirmCodeViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Text fields
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeTextFieldContainer: UIView!
    
    // Buttons
    @IBOutlet weak var confirmButton: UIButton!
    
    // Label
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Service
    lazy var behaviorService = ConfirmCodeBehaviorService(owner: self)
    
    //MARK: - Lifecycle
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
