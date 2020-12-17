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
    private let tokenProvider = TokenProvider()
    
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
            .asObservable()
            .validate()
            .mapTo(Void())
    }
    
    func confirmPhone(email: String, code: String) -> Observable<Void> {
        return requestProvider.rx
            .request(.confirmPhone(email: email, code: code))
            .asObservable()
            .validate()
            .mapTo(Void())
    }
    
    func authorizate(email: String, password: String) -> Observable<UserDataModel> {
        return requestProvider.rx
            .request(.getToken(email: email, password: password))
            .asObservable()
            .validate()
            .map {[unowned self] (response) in
                do {
                    let data = try response.map(UserDataModel.self)
                    let auth = try response.map(UserAuthorizationModel.self)
                    self.tokenProvider.authorization = auth
                    return data
                } catch {
                    throw Errors.objectMapping
                }
            }
    }
    
    func logout() -> Observable<Void> {
        tokenProvider.authorization = nil
        return Observable<Void>.just(())
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

//MARK: - TokenProvider
import MagicalRecord

private class TokenProvider {
    var authorization: UserAuthorizationModel? {
        didSet {
            
            MagicalRecord.save(blockAndWait: { contenxt in
                UserAuthDBModel.mr_truncateAll(in: contenxt)
            })
             
            guard authorization != nil else { return }
            
            MagicalRecord.save ({[unowned self] (context) in
                let authDB = UserAuthDBModel.mr_createEntity(in: context)
                authDB?.accessToken = self.authorization?.accessToken
                authDB?.refreshToken = self.authorization?.refreshToken
                authDB?.accessTokenExpiresAt = self.authorization?.accessTokenExpiresAt
                authDB?.refreshTokenExpiresAt = self.authorization?.refreshTokenExpiresAt
            })
        }
    }
    
    init() {
        guard let authDB = UserAuthDBModel.mr_findFirst() else { return }
        authorization = UserAuthorizationModel(accessToken: authDB.accessToken!,
                                               refreshToken: authDB.refreshToken!,
                                               accessTokenExpiresAt: authDB.accessTokenExpiresAt!,
                                               refreshTokenExpiresAt: authDB.refreshTokenExpiresAt!)
    }
    
}
