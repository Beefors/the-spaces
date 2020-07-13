//
//  NetworkService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 11.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class NetworkService: NSObject {
    
    static let shared = NetworkService()
    
    private let requestProvider = MoyaProvider<ApiProvider>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: [.formatRequestAscURL, .successResponseBody]))])
    
    func citiesList() -> Observable<Array<CityModel>> {
        return requestProvider.rx
            .request(.avalibleCities)
            .modelMap(Array<CityModel>.self)
            .asObservable()
    }
    
    func placesList(cityId: Int) -> Observable<Array<PlaceModel>> {
        return requestProvider.rx
            .request(.placesList(byCity: cityId))
            .modelMap(Array<PlaceModel>.self)
            .asObservable()
    }
    
}
