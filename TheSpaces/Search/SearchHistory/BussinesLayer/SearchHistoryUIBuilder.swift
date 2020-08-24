//
//  SearchHistoryUIBuilder.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class SearchHistoryUIBuilder: UIBuilderType {
    
    //MARK: Owner
    unowned(unsafe) let owner: SearchHistoryViewController
    unowned(unsafe) var searchPanel: SearchPanelView!
    
    //MARK: - Properties
    private(set) var topInset = CGFloat()
    
    //MARK: - Initialization
    init(owner: SearchHistoryViewController) {
        self.owner = owner
    }
    
    //MARK: - Helpers
    func buildUI() {
        
        let inset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        owner.tableView.contentInset = inset
        owner.tableView.scrollIndicatorInsets = inset
        owner.tableView.separatorInset = .zero
        
        owner.tableViewLeadingConstr.constant = 17
        owner.tableViewTrailingConstr.constant = owner.view.bounds.width - (searchPanel.frame.minX + searchPanel.textField.frame.maxX)
        
        searchPanel.textField.returnKeyType = .done
        owner.tableView.keyboardDismissMode = .interactive
    }
    
    func setupTopInset(searchPanel: SearchPanelView) {
        self.searchPanel = searchPanel
        topInset = searchPanel.frame.maxY + 10
    }
    
}
