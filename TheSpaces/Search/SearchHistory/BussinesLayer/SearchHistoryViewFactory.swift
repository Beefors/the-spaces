//
//  SearchHistoryViewFactory.swift
//  TheSpaces
//
//  Created by Денис Швыров on 03.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class SearchHistoryViewFactory {
    
    static func createHistorySectionHeaderView() -> SearchHistoryHeaderView {
        return SearchHistoryHeaderView()
    }
    
    static func createSearchSectionHeaderView(leadingOffset: CGFloat) -> UIView {
        
        let view = UIView()
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingOffset),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.backgroundColor = .white
        label.textColor = .black
        label.font = .tabbarTitles
        
        label.text = "Результаты"
        
        return view
    }
    
    static func createRefreshControl() -> UIRefreshControl {
        return UIRefreshControl()
    }
    
    static func registerCells(tableView: UITableView) {
        tableView.register(SearchResultItemCell.self, forCellReuseIdentifier: SearchResultItemCell.reuseIdentifier)
        tableView.register(SearchHistoryItemCell.self, forCellReuseIdentifier: SearchHistoryItemCell.reuseIdentifier)
    }
    
    static func dequeueSearchResultCell(tableView: UITableView) -> SearchResultItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultItemCell.reuseIdentifier) as! SearchResultItemCell
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    static func dequeueSearchHistoryItemCell(tableView: UITableView) -> SearchHistoryItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryItemCell.reuseIdentifier) as! SearchHistoryItemCell
        return cell
    }
    
}
