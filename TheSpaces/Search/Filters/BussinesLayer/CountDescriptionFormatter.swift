//
//  CountDescriptionFormatter.swift
//  TheSpaces
//
//  Created by Денис Швыров on 06/05/2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

/// Only for Russian

class CountDescriptionFormatter {
    
    enum RussianCases {
        case nominative
        case genitive
    }
    
    enum RussianCalculus {
        case singular
        case plural
    }
    
    var count: Int
    var denomination: DenominationType
    
    init(count: Int = 0, denomination: DenominationType) {
        self.count = count
        self.denomination = denomination
    }
    
    private func caseByNumber(_ number: Int) -> RussianCases {
        return number == 1 || number % 10 == 1 ? .nominative : .genitive
    }
    
    private func calculusByNumber(_ number: Int) -> RussianCalculus {
        
        switch number {
        case 11...14: return .plural
        default: break
        }
        
        let residue = number % 10
        
        switch residue {
        case 1...4: return .singular
        default: return .plural
        }
        
    }
    
    typealias TimeElementParams = (case: RussianCases, calculus: RussianCalculus)
    
    private func paramsByNumber(_ number: Int) -> TimeElementParams {
        return TimeElementParams(case: caseByNumber(number), calculus: calculusByNumber(number))
    }
    
    struct DenominationValue{
        let count: Int
        let description: String
        
        func toForm() -> String {
            return "\(count) \(description)"
        }
        
    }
    
    func denominationValue() -> DenominationValue {
        let params = paramsByNumber(count)
        return DenominationValue(count: count, description: denomination.description(by: params))
    }
    
    func toForm() -> String {
        denominationValue().toForm()
    }
    
}

protocol DenominationType {
    func description(by params: CountDescriptionFormatter.TimeElementParams) -> String
}

struct PlacesDenomination: DenominationType {
    func description(by params: CountDescriptionFormatter.TimeElementParams) -> String {
        switch params {
        case (.nominative, .singular): return "место"
        case (_, .singular): return "места"
        case (_, .plural): return "мест"
        }
    }
}
