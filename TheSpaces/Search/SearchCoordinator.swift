//
//  SearchCoordinator.swift
//  TheSpaces
//
//  Created by Денис Швыров on 07.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit.UIViewController

enum SearchCoordinator {
    case main
    case placesList(searchPanelView: SearchPanelView, placesDataViewModel: PlacesViewModel)
    case searchHistory
    case filters
}

extension SearchCoordinator: StoryboardCoordinator {
    var storyboardName: String { "Search" }
    
    var controllerID: String {
        switch self {
        case .main: return "Main"
        case .placesList: return "PlacesList"
        case .searchHistory: return "SearchHistory"
        case .filters: return "Filters"
        }
    }
    
    func prepare(viewController: UIViewController) {
        switch self {
        case .placesList(let searchPanelView, let placesDataViewModel):
            let placesListVC = viewController as! PlacesListViewController
            
            placesListVC.searchPanelView = searchPanelView
            placesListVC.builderUI = PlacesListUIBuilder(owner: placesListVC, tableViewTopInset: searchPanelView.frame.maxY)
            placesListVC.behaviorService = PlacesListBehaviorService(owner: placesListVC, placesDataProvider: placesDataViewModel)
            
        case .searchHistory:
            break
            
        case .filters:
            viewController.modalPresentationStyle = .fullScreen
            
        default: break
        }
    }
    
}
