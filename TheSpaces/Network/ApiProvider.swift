//
//  ApiProvider.swift
//  TheSpaces
//
//  Created by Денис Швыров on 11.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Moya
import Foundation

enum ApiProvider {
    case avalibleCities
    case placesList(byCity: Int, filters: [PlacesFilter]?)
    case getPlace(id: Int)
    case placeImage(placeId: Int, imageNumber: Int)
}

protocol ApiEnvironmentProvider {
    var environmentURL: URL {get}
}
 
enum ApiEnvironment {
    case development
    case production
}

extension ApiEnvironment: ApiEnvironmentProvider {
    var environmentURL: URL {
        switch self {
        case .development: return URL(string: "https://thespacesstage.azurewebsites.net/api/")!
        case .production: abort()
        }
    }
}

extension ApiProvider: ApiEnvironmentProvider {
    var environmentURL: URL {
        return ApiEnvironment.development.environmentURL
    }
}

extension ApiProvider: TargetType {
    var baseURL: URL { return environmentURL }
    
    var path: String {
        switch self {
        case .avalibleCities: return "dictionaries/cities"
        case .placesList: return "Entities"
        case .getPlace(let id): return "entities/\(id)"
        case .placeImage(let id, let imageNumber): return "entities/\(id)/image/\(imageNumber)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .placesList: return .post
        default: return .get
        }
    }
    
    var sampleData: Data { Data() }
    
    var parameters: [String: Any]? {
        switch self {
        case .avalibleCities: return nil
        case .placesList(let cityId, let filters):
            
            var params: Dictionary<String, Any> = ["cityId": cityId]
            
            if let filters = filters {
                for filter in filters {
                    params[filter.key] = filter.value
                }
            }
            
            return params
            
        case .getPlace: return nil
        case .placeImage: return nil
        }
    }
    
    var task: Task {
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: JSONEncoding.default)
        }
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

extension ApiProvider: MoyaCacheable {
    var cachePolicy: MoyaCacheablePolicy {
        switch self {
        case .placesList: return .useProtocolCachePolicy
        default: return .reloadIgnoringLocalAndRemoteCacheData
        }
    }
}

protocol MoyaCacheable {
  typealias MoyaCacheablePolicy = URLRequest.CachePolicy
  var cachePolicy: MoyaCacheablePolicy { get }
}
