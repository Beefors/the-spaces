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
    
    // Cities
    case avalibleCities
    
    // Places
    case placesList(byCity: Int, filters: [PlacesFilter]?)
    case getPlace(id: Int)
    case placeImage(placeId: Int, imageNumber: Int)
    
    // Filters
    case filtersPlacesCount(byCity: Int, filters: [PlacesFilter])
    
    // Registration / Authorization
    case register(data: RegisterRequestModel)
    case sendPhoneCode(email: String)
    case confirmPhone(email: String, code: String)
    case getToken(email: String, password: String)
    case refreshToken(refreshToken: String)
    
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
        
        // Cities
        case .avalibleCities: return "dictionaries/cities"
            
        // Places
        case .placesList: return "Entities"
        case .getPlace(let id): return "entities/\(id)"
        case .placeImage(let id, let imageNumber): return "entities/\(id)/image/\(imageNumber)"
            
        // Filters
        case .filtersPlacesCount: return "Entities/filterCount"
            
        // Registration / Authorization
        case .register: return "Users/register"
        case .sendPhoneCode: return "Users/sendPhoneCode"
        case .confirmPhone: return "Users/confirmPhone"
        case .getToken: return "Users/token"
        case .refreshToken: return "Users/refresh"
            
        }
    }
    
    var method: Moya.Method {
        return parameters != nil || encodeData != nil ? .post : .get
    }
    
    var sampleData: Data { Data() }
    
    var parameters: [String: Any]? {
        switch self {
        
        // Cities
        case .avalibleCities: return nil
            
        // Places
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
            
        // Filters
        case .filtersPlacesCount(let cityId, let filters):
            
            var params: Dictionary<String, Any> = ["cityId": cityId]
            
            for filter in filters {
                params[filter.key] = filter.value
            }
            
            return params
            
        // Registration / Authorization
        case .register: return nil
        case .sendPhoneCode(let email): return nil
        case .confirmPhone(let email, let code): return ["email": email,
                                                         "code": code]
        case .getToken(let email, let password): return ["userName": email,
                                                         "password": password]
        case .refreshToken(let refreshToken): return ["token": refreshToken]
        }
    }
    
    var encodeData: Encodable? {
        switch self {
        
        // Registration / Authorization
        case .register(let data): return data
            
        // Other
        default: return nil
        }
    }
    
    var task: Task {
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: JSONEncoding.default)
        } else if let encodedData = encodeData {
            return .requestJSONEncodable(encodedData)
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
