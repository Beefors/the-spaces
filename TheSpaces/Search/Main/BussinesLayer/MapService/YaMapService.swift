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
    
    //MARK: Owner
    unowned(unsafe) private(set) var controller: MapViewController

    //MARK: - Variables
    weak var delegate: MapServiceDelegate?
    
    //MARK: - Private properties
    private let mapView: YMKMapView
    private let map: YMKMap
    private let userLocationLayer: YMKUserLocationLayer
    private var clusterizedCollection: YMKClusterizedPlacemarkCollection!
    private var markersAdapters = Set<MarkerAdapter>()
    
    //MARK: - Initialization
    init(_ controller: MapViewController) {
        self.controller = controller
        mapView = YMKMapView()
        map = mapView.mapWindow.map
        
        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        
        super.init()
        
        clusterizedCollection = map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        userLocationLayer.setObjectListenerWith(self)
    }
    
    //MARK: - Main logic
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
            
            let view = MapServiceViewsFactory.createMarkerView(isSelected: false, place: place)
            
            let point = place.coordinate.toYMKPoint()
            let marker = clusterizedCollection.addPlacemark(with: point, view: YRTViewProvider(uiView: view))
            marker.addTapListener(with: self)
            
            markersAdapters.insert(MarkerAdapter(marker: marker, place: place))
        }
        
        clusterizedCollection.clusterPlacemarks(withClusterRadius: 20, minZoom: 15)
    }
    
    func deselectPlace(_ place: PlaceModel) {
        let adapter = markersAdapters.first(where: {$0.place == place})
        adapter?.marker.setViewWithView(YRTViewProvider(uiView: MapServiceViewsFactory.createMarkerView(isSelected: false, place: place)))
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
        
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false }
        guard let adapter = markersAdapters.first(where: { $0.marker == placemark }) else { return false }
        
        // Disabling all markers without new selected placemark
        markersAdapters.subtracting([adapter]).forEach({$0.marker.setViewWithView(YRTViewProvider(uiView: MapServiceViewsFactory.createMarkerView(isSelected: false, place: $0.place)))})
        
        let view = MapServiceViewsFactory.createMarkerView(isSelected: true, place: adapter.place)
        placemark.setViewWithView(YRTViewProvider(uiView: view))
        delegate?.mapService(self, didSelectPlace: adapter.place)
        
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

extension YaMapService {
    class MarkerAdapter: NSObject {
        let marker: YMKPlacemarkMapObject
        let place: PlaceModel
        
        required init(marker: YMKPlacemarkMapObject, place: PlaceModel) {
            self.marker = marker
            self.place = place
        }
    }
}
