//
//  MapServiceType.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation.CLLocation
import RxSwift
import RxCocoa

enum ZoomType: Int {
    case current
    case near
}

protocol MapServiceType: class {
    func setup()
    func goToLocation(_ location: CLLocationCoordinate2D, zoom zoomType: ZoomType, animated: Bool)
    func presentPlaces(_ places: Array<PlaceModel>)
    
    var delegate: MapServiceDelegate? {get set}
    
}

protocol MapServiceDelegate: class {
    func mapService(_ mapService: MapServiceType, didSelectPlace place: PlaceModel)
}

extension MapServiceDelegate {
    func mapService(_ mapService: MapServiceType, didSelectPlace: PlaceModel) {}
}

extension Reactive where Base: MapServiceType {
    var presentPlaces: Binder<Array<PlaceModel>> {
        return .init(base) { (mapServise, places) in
            mapServise.presentPlaces(places)
        }
    }
    
    var positionAction: Binder<MapPositionAction> {
        return .init(base) { (mapService, action) in
            mapService.goToLocation(action.coordinate, zoom: action.zoom, animated: action.animated)
        }
    }
    
}

struct MapPositionAction {
    let coordinate: CLLocationCoordinate2D
    let zoom: ZoomType
    let animated: Bool
}

extension PlaceModel {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
}
