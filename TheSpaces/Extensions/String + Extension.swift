//
//  String + Extension.swift
//  TheSpaces
//
//  Created by Денис Швыров on 30.11.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
    
    func filteredDecimalDigit() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func matches(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func isValidEmail() -> Bool {
        return matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    func countInstances(of stringToFind: String) -> Int {
        guard !stringToFind.isEmpty else { return 0 }
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
    
}
