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
    case placesList(byCity: Int)
    case getPlace(id: Int)
    case placeImage(placeId: Int, imageNumber: Int)
}

extension ApiProvider: TargetType {
    var baseURL: URL { return URL(string: "https://thespacesstage.azurewebsites.net/api/")! }
    
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
        case .placesList(let cityId): return ["cityId": cityId]
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
