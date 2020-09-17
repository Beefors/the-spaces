//
//  FiltersRadioButtonViewsFactory.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import UIKit

class FiltersRadioButtonViewsFactory {
    class func dequeueCell(tableView: UITableView) -> RadioButtonCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "radioButton") as! RadioButtonCell
        cell.checkButton.contentInset.top = 10
        cell.checkButton.contentInset.bottom = 10
        cell.checkButton.contentInset.left = 20
        
        return cell
    }
}
