//
//  FiltersViewsFactory.swift
//  TheSpaces
//
//  Created by Денис Швыров on 27.08.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class FiltersViewsFactory {
    
    static func dequeuPriceCell(for tableView: UITableView) -> FilterRangeSliderCell {
        let identifier = "SliderCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! FilterRangeSliderCell
        return cell
    }
    
    static func dequeuSpecificationCell(for tableView: UITableView) -> FilterSubtitleCell {
        let identifier = "SubtitleCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! FilterSubtitleCell
        return cell
    }
    
}
