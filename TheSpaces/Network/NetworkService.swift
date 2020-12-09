//
//  NetworkService.swift
//  TheSpaces
//
//  Created by Денис Швыров on 11.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Moya

class NetworkService: NSObject {
    
    static let shared = NetworkService()
    
    private let requestProvider = MoyaProvider<ApiProvider>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: [.formatRequestAscURL, .successResponseBody])), MoyaCacheablePlugin()])
    
    //MARK: - Cities
    func citiesList() -> Observable<Array<CityModel>> {
        return requestProvider.rx
            .request(.avalibleCities)
            .modelMap(Array<CityModel>.self)
            .asObservable()
    }
    
    //MARK: - Places list
    func placesList(cityId: Int, filters: [PlacesFilter]? = nil) -> Observable<Array<PlaceModel>> {
        return requestProvider.rx
            .request(.placesList(byCity: cityId, filters: filters))
            .modelMap(Array<PlaceModel>.self)
            .asObservable()
    }
    
    //MARK: - Filters
    func filterPlacesCount(cityId: Int, filters: [PlacesFilter]) -> Observable<Int> {
        return requestProvider.rx
            .request(.filtersPlacesCount(byCity: cityId, filters: filters))
            .modelMap(Int.self, atKeyPath: "count")
            .asObservable()
    }
    
    //MARK: - Users
    func register(request: RegisterRequestModel) -> Observable<Void> {
        return requestProvider.rx
            .request(.register(data: request))
            .debug()
            .map({ (response) in
                switch response.statusCode {
                case 200: return
                case 500: throw Errors.serverNotResponding
                default:
                    do {
                        let string = try response.mapString()
                        throw RawStringError(value: string)
                    } catch let e as RawStringError {
                        throw e
                    } catch {
                        throw Errors.objectMapping
                    }
                }

            })
            .asObservable()
    }
    
}

final class MoyaCacheablePlugin: PluginType {
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    if let moyaCachableProtocol = target as? MoyaCacheable {
      var cachableRequest = request
      cachableRequest.cachePolicy = moyaCachableProtocol.cachePolicy
      return cachableRequest
    }
    return request
  }
}
