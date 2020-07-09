//
//  YaMapService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 09.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import CoreLocation
import YandexMapKit
import RxSwift
import RxCocoa

class YaMapService: NSObject, MapServiceType {
    
    unowned(unsafe) private(set) var controller: SearchViewController
    let mapView: YMKMapView
    let map: YMKMap
    let userLocationLayer: YMKUserLocationLayer
    
    init(_ controller: SearchViewController) {
        self.controller = controller
        mapView = YMKMapView()
        map = mapView.mapWindow.map
        
        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        super.init()
        userLocationLayer.setObjectListenerWith(self)
    }
    
    func setup() {
        mapView.frame = controller.view.bounds
        controller.view.insertSubview(mapView, at: 0)
        map.addCameraListener(with: self)
        map.move(with: .moscowCenter)

//        userLocationLayer.setTapListenerWith(self)
        userLocationLayer.setVisibleWithOn(true)
    }
    
    func goToLocation(_ location: CLLocationCoordinate2D,  zoom zoomType: ZoomType, animated: Bool) {
        
        let zoom = zoomType == .current ? map.cameraPosition.zoom : 16
        
        let camera = YMKCameraPosition(target: location.toYMKPoint(),
                                       zoom: zoom,
                                       azimuth: map.cameraPosition.azimuth,
                                       tilt: map.cameraPosition.tilt)
        
        if animated {
            map.move(with: camera, animationType: YMKAnimation(type: .smooth, duration: 0.5), cameraCallback: nil)
        } else {
            map.move(with: camera)
        }
        
    }
    
    func goToUserPosition() {
        guard let userCamera = userLocationLayer.cameraPosition() else { return }
        map.move(with: userCamera, animationType: YMKAnimation(type: .smooth, duration: 0.5), cameraCallback: nil)
    }
}

extension YaMapService: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
//            print("\(cameraPosition.target.latitude) \(cameraPosition.target.longitude) \(cameraPosition.zoom)")
        }
}

// Customiztion user marker
extension YaMapService: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {
        
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        
    }
    
}
