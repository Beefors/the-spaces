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
        SearchHistoryViewFactory.registerCells(tableView: owner.tableView)
        owner.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        searchPanel.textField.returnKeyType = .done
        owner.tableView.keyboardDismissMode = .interactive
    }
    
    func setupTopInset(searchPanel: SearchPanelView) {
        self.searchPanel = searchPanel
        topInset = searchPanel.frame.maxY        
    }
    
}
