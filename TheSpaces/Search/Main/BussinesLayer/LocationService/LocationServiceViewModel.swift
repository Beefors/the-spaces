//
//  LocationServiceViewModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class LocationServiceViewModel: ViewModelType {
    let bag = DisposeBag()
    let locationManager: CLLocationManager
    
    let hasPermissionsObservable = BehaviorRelay<Bool>(value: false)
    let userLocationObservable = BehaviorRelay<CLLocation?>(value: nil)
    
    init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        setupObservables()
    }
    
    func setupObservables() {
        
        let curStatusObservable = locationManager.rx.status
        let statusDidChangeObservable = locationManager.rx.didChangeAuthorization.map({$0.status})
        
        Observable<CLAuthorizationStatus>.merge(curStatusObservable, statusDidChangeObservable)
            .map({ (status) -> Bool in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse: return true
                default: return false
                }
            })
            .bind(to: hasPermissionsObservable)
            .disposed(by: bag)
        
        locationManager.rx
            .location
            .bind(to: userLocationObservable)
            .disposed(by: bag)
        
    }
    
    func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
}
