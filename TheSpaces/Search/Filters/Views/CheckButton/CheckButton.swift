//
//  CheckButton.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckButton: UIView {
    
    //MARK: Properties
    var itemsInset: CGFloat = 7.4 {
        didSet {
            updateLayout()
        }
    }
    
    var contentInset = UIEdgeInsets() {
        didSet {
            updateLayout()
        }
    }
    
    var isSelected = false {
        didSet {
            render()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var topContentConstr: NSLayoutConstraint!
    @IBOutlet weak var leadingContentConstr: NSLayoutConstraint!
    @IBOutlet weak var trailingContentContr: NSLayoutConstraint!
    @IBOutlet weak var bottomContentConstr: NSLayoutConstraint!
    @IBOutlet weak var itemInsetConstr: NSLayoutConstraint!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var label: UILabel!
    
    //MARK: - initializaation
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Helpers
    private func commonInit() {
        
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: mainView.topAnchor),
            leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        checkView.tintColor = .STBlue
        checkView.layer.cornerRadius = checkView.bounds.height / 2
        checkView.layer.borderColor = UIColor.STGrayUnderline.cgColor
        label.font = .historyNotWeight
        
        updateLayout()
        render()
        
    }
    
    private func render() {
        checkView.backgroundColor = isSelected ? checkView.tintColor : .clear
        checkView.layer.borderWidth = !isSelected ? 1.4 : 0
    }
    
    private func updateLayout() {
        topContentConstr.constant = contentInset.top
        leadingContentConstr.constant = contentInset.left
        trailingContentContr.constant = contentInset.right
        bottomContentConstr.constant = contentInset.bottom
        itemInsetConstr.constant = itemsInset
    }
    
}

extension Reactive where Base: CheckButton {
    var isSelected: Binder<Bool> {
        return Binder<Bool>(base) { (target, value) in
            target.isSelected = value
        }
    }
}
