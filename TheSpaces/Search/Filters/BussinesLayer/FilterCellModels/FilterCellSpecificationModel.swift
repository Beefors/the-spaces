//
//  FilterCellSpecificationModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 06.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FilterCellSpecificationModel: FilterCellModelType {
    let bag = DisposeBag()
    let specificationType: FiltersDataSource.Sections.SpecificationsTypes
    
    init(specificationType: FiltersDataSource.Sections.SpecificationsTypes) {
        self.specificationType = specificationType
    }
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return FiltersViewsFactory.dequeuSpecificationCell(for: tableView)
    }
    
    func setupCell(_ cell: UITableViewCell) {
        guard let cell = cell as? FilterSubtitleCell else { return }
        cell.label.text = specificationType.title
        cell.subtitleLabel.text = "Выбрать"
    }
    
}
