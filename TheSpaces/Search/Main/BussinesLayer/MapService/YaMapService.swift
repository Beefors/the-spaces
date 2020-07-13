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
    private(set) var clusterizedCollection: YMKClusterizedPlacemarkCollection!
    
    init(_ controller: SearchViewController) {
        self.controller = controller
        mapView = YMKMapView()
        map = mapView.mapWindow.map
        
        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        
        super.init()
        
        clusterizedCollection = map.mapObjects.addClusterizedPlacemarkCollection(with: self)
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
    
    func presentPlaces(_ places: Array<PlaceModel>) {
        
        clusterizedCollection.clear()
        
        for place in places {
            
            let label = UILabel(frame: CGRect(origin: CGPoint(x: 10.52, y: 5.44), size: .zero))
            label.font = .priceButton
            label.text = "\(Int(place.minPrice))₽"
            
            label.sizeToFit()
            
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: label.frame.maxX + 8.35, height: label.frame.maxY + 4.94)))
            view.addSubview(label)
            view.backgroundColor = .white
            view.layer.cornerRadius = view.bounds.height / 2
            
            let point = place.coordinate.toYMKPoint()
            let marker = clusterizedCollection.addPlacemark(with: point, view: YRTViewProvider(uiView: view, cacheable: false))
            marker.addTapListener(with: self)
        }
        
        clusterizedCollection.clusterPlacemarks(withClusterRadius: 10, minZoom: 15)
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

extension YaMapService: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        return true
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

// Setup cluster style
extension YaMapService: YMKClusterListener {
    func onClusterAdded(with cluster: YMKCluster) {
        cluster.appearance.setIconWith(#imageLiteral(resourceName: "clusterIcon"))
    }
}

