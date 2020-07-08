//
//  SearchVC + Map.swift
//  TheSpaces
//
//  Created by Денис Швыров on 08.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import YandexMapKit

extension SearchViewController: YMKMapCameraListener {//, YMKClusterListener, YMKClusterTapListener {
    
    func setupMap() {
        
        mapView.frame = view.bounds
        view.insertSubview(mapView, at: 0)
        
        map.addCameraListener(with: self)
        
        map.move(with: .moscowCenter)
    }
    
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
//        print("\(cameraPosition.target.latitude) \(cameraPosition.target.longitude) \(cameraPosition.zoom)")
    }
    
}
