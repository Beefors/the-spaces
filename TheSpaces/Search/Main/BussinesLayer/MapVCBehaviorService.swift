//
//  MapVCBehaviorService.swift
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
import RxAppState
import RxKeyboard

class MapVCBehaviorService: NSObject {
    unowned(unsafe) let owner: MapViewController
    
    //MARK: Services
    lazy var mapService: MapServiceType = YaMapService(owner)
    lazy var locationService = LocationService(parent: owner)
    lazy var placePreviewService = MapPlacePreviewService(owner: owner)
    lazy var searchViewModel = MapViewModel()
    lazy var presentationService: MapPresentationServiceType = MapPresentationService(parent: owner)
    
    //MARK: - Initialization
    init(_ controller: MapViewController) {
        owner = controller
        super.init()
    }
    
    //MARK: - Methods
    func setup() {
        
        // Setup services
        mapService.setup()
        locationService.setup()
        placePreviewService.setup()
        
        mapService.delegate = self
        placePreviewService.delegate = self
        
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
        
        // Show places list screen
        Observable.just(self)
            .flatMap { (behaviorService) in
                return behaviorService.owner.showListButton.rx.tap.map({behaviorService})
            }
            .flatMap({ (behaviorService) -> Observable<MapVCBehaviorService> in
                let placesListCoordinator = SearchCoordinator.placesList(searchPanelView: behaviorService.owner.searchPanelView, placesDataViewModel: behaviorService.searchViewModel)
                let placesListVC = placesListCoordinator.viewController as! PlacesListViewController
                
                behaviorService.presentationService.present(viewController: placesListVC)
                
                return placesListVC.dismissButton.rx.tap.map({behaviorService})
            })
            .do(onNext: { (behaviorService) in
                behaviorService.presentationService.dismissPresented()
            })
            .subscribe()
            .disposed(by: searchViewModel)
        
        // Show search history screen
        Observable.just(self)
            .flatMap { (behaviorService) in
                return behaviorService.owner.searchPanelView.textField.rx.controlEvent(.editingDidBegin).map({behaviorService})
            }
            .flatMap { (behaviorService) -> Observable<MapVCBehaviorService> in
                let searchHistoryCoordinator = SearchCoordinator.searchHistory
                let searchHistoryVC = searchHistoryCoordinator.viewController as! SearchHistoryViewController
                searchHistoryVC.setup(byParent: behaviorService.owner)
                
                behaviorService.presentationService.present(viewController: searchHistoryVC)
                
                let backButton = UIButton(type: .system)
                backButton.setImage(UIImage(named: "backArrow")!, for: .normal)
                backButton.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
                
                behaviorService.owner.searchPanelView.setupCustomAccesoryView(backButton, animation: true)
                
                let keyboardDismissTrigger = RxKeyboard.instance.isHidden.filter({$0}).asObservable().skip(1).take(1).map({ _ in return })
                let backButtonDismissTrigger = backButton.rx.tap.take(1).do(onNext: {[unowned self] in
                    self.owner.searchPanelView.textField.resignFirstResponder()
                })
                
                return Observable<Void>.merge(keyboardDismissTrigger, backButtonDismissTrigger)
                    .do(onNext: {[unowned self] in
                        self.owner.searchPanelView.setupDefaultAccesoryView(animation: true)
                    })
                    .map({ _ in return behaviorService})
            }
            .do(onNext: { (behaviorService) in
                behaviorService.presentationService.dismissPresented()
            })
            .subscribe()
            .disposed(by: searchViewModel)
        
        // Show filters screen
        owner.searchPanelView.optionsButton.rx
            .tap
            .map { _ -> Coordinator in
                SearchCoordinator.filters
            }
            .map { (coordinator) -> UIViewController? in
                RouterManager.shared.present(coordinator, presentationType: .present(animated: true, completion: nil))
            }
            .filterNil()
            .do(onNext: {[unowned self] (_) in
                self.owner.searchPanelView.optionsButton.isUserInteractionEnabled = false
            })
            .flatMap { (viewController) -> Observable<Void> in
                viewController.rx.viewDidDisappear.map({_ in return })
            }
            .do(onNext: {[unowned self] (_) in
                self.owner.searchPanelView.optionsButton.isUserInteractionEnabled = true
            })
            .subscribe()
            .disposed(by: searchViewModel)
            
    }
    
}

extension MapVCBehaviorService: MapServiceDelegate {
    func mapService(_ mapService: MapServiceType, didSelectPlace place: PlaceModel) {
        placePreviewService.showPreview(withPlace: place)
    }
}

extension MapVCBehaviorService: SearchPlacePreviewServiceDelegate {
    func placePreviewService(_ service: MapPlacePreviewService, didHidePreviewForPlace place: PlaceModel) {
        mapService.deselectPlace(place)
    }
}
