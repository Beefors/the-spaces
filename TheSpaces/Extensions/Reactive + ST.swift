//
//  Reactive + ST.swift
//  TheSpaces
//
//  Created by Денис Швыров on 12.07.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func modelMap<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
        return flatMap {
            
            do {
                return .just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData))
            } catch {
                throw Errors.objectMapping
            }
            
        }
    }
    
}
