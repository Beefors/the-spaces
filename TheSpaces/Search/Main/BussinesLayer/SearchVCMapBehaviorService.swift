//
//  SearchVCBehaviorService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional

class SearchVCMapBehaviorService: NSObject {
    unowned(unsafe) private(set) var owner: SearchViewController
    
    //MARK: Services
    lazy var mapService: MapServiceType = YaMapService(owner)
    lazy var locationService = LocationService(parent: owner)
    lazy var searchViewModel = SearchViewModel()
    
    //MARK: - Initialization
    init(_ controller: SearchViewController) {
        owner = controller
        super.init()
    }
    
    //MARK: - Methods
    func setup() {
        
        // Setup services
        mapService.setup()
        locationService.setup()
        
        // Load places
        searchViewModel.getPlacesTrigger.accept(())
        
        // Enabling/disabling user location button
        locationService.viewModel
            .hasPermissionsObservable
            .bind {[unowned self] (isSuccessfull) in
                if isSuccessfull {
                    self.owner.userLocationButton.isHidden = false
                    self.owner.userLocationButton.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.3, animations: {[unowned self] in
                    self.owner.userLocationButton.alpha = isSuccessfull ? 1.0 : 0.0
                }) {[unowned self] (isComplate) in
                    self.owner.userLocationButton.isHidden = !isSuccessfull
                }
                
            }
            .disposed(by: locationService.viewModel)
        
        // Show user position on map
        locationService.viewModel
            .userLocationObservable
            .filterNil()
            .take(1)
            .bind {[unowned self] (location) in
                self.mapService.goToLocation(location.coordinate, zoom: .near, animated: true)
            }
            .disposed(by: locationService.viewModel)
        
        // Show user position on map by user action
        owner.userLocationButton.rx
            .tap
            .subscribe(onNext: {[unowned self] in
                guard let coordinate = self.locationService.viewModel.userLocationObservable.value else { return }
                self.mapService.goToLocation(coordinate.coordinate, zoom: .near, animated: true)
            })
            .disposed(by: locationService.viewModel)
        
        // Show places on map
        searchViewModel.placesObservable
            .subscribe(onNext: {[unowned self] (places) in
                self.mapService.presentPlaces(places)
            })
            .disposed(by: searchViewModel)
        
        owner.showListButton.rx
            .tap
            .bind {[unowned self] _ in
                let vc = UIViewController()
                
                vc.view.backgroundColor = .red
                vc.modalPresentationStyle = .overCurrentContext
                
                self.owner.present(vc, animated: true, completion: nil)
            }
            .disposed(by: searchViewModel)
        
    }
    
}
