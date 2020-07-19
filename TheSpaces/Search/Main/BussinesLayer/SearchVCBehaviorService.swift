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
import RxAppState

class SearchVCBehaviorService: NSObject {
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
        
        // Show places list screen
        Observable.just(self)
            .flatMap { (behaviorService) in
                return behaviorService.owner.showListButton.rx.tap.map({behaviorService})
            }
            .do(onNext: { (behaviorService) in
                
                let placesList = SearchCoordinator.placesList(searchPanelView: behaviorService.owner.searchPanelView, placesDataViewModel: behaviorService.searchViewModel).viewController
                
                behaviorService.owner.addChild(placesList)
                behaviorService.owner.view.insertSubview(placesList.view, belowSubview: behaviorService.owner.searchPanelView)
                
                placesList.view.frame.size = behaviorService.owner.view.bounds.size
                placesList.view.frame.origin = CGPoint(x: .zero, y: behaviorService.owner.view.bounds.height)
                
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {[unowned placesList] in
                    placesList.view.frame.origin = .zero
                }, completion: nil)
                
            })
            .subscribe()
            .disposed(by: searchViewModel)
        
//        owner.showListButton.rx
//            .tap
//            .map({[unowned self] (_) -> SearchVCBehaviorService in
//                return self
//            })
//            .do(onNext: { (service) in
//                service.owner.searchPanelView.transite(to: TabBarSource.shared.tabBarController.view)
//            })
//            .flatMap({ behaviorService -> Observable<(SearchVCBehaviorService, UIViewController)> in
//                return Observable<UIViewController>.create { (observer) -> Disposable in
//                    let coordinator = SearchCoordinator.placesList(searchPanelView: behaviorService.owner.searchPanelView, placesDataViewModel: behaviorService.searchViewModel)
//
//                    RouterManager.shared.present(coordinator, presentationType: .present(animated: true) { presentingVC in
//                        guard presentingVC != nil else {
//                            observer.onCompleted()
//                            return
//                        }
//
//                        observer.on(.next(presentingVC!))
//                        observer.onCompleted()
//                    })
//
//                    return Disposables.create()
//                }
//                .map({ (behaviorService, $0) })
//            })
//            .bind { behaviorService, presentingVC in
//                behaviorService.owner.searchPanelView.transite(to: presentingVC.view)
//            }
//            .disposed(by: searchViewModel)
        
//        owner.showListButton.rx
//            .tap
//            .map({[unowned self] _ -> UIViewController? in
//
//                self.owner.searchPanelView.transite(to: self.owner.navigationController!.view)
//
//                return RouterManager.shared.present(SearchCoordinator.placesList(searchPanelView: self.owner.searchPanelView, placesDataViewModel: self.searchViewModel), presentationType: .push(by: .onSelectedTab, animated: .fromBottom))
//            })
//            .filterNil()
////            .flatMap({ viewController in
////                return viewController.rx.viewDidAppear.take(1).map({ _ in viewController })
////            })
//            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
//            .bind {[unowned self] (viewController) in
//                self.owner.searchPanelView.transite(to: viewController.view)
//            }
//            .disposed(by: searchViewModel)
        
    }
    
}
