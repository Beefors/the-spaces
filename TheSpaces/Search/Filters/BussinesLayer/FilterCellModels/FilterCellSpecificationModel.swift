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

class FilterCellSpecificationModel: TableCellModelType {
    let bag = DisposeBag()
    let specificationType: FiltersDataSource.Sections.SpecificationsTypes
    
    let rowDidSelectObservable = PublishRelay<FiltersDataSource.Sections.SpecificationsTypes>()
    let selectedFilterObservable = BehaviorRelay<TitlePresentable?>(value: nil)
    
    init(specificationType: FiltersDataSource.Sections.SpecificationsTypes) {
        self.specificationType = specificationType
    }
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return FiltersViewsFactory.dequeuSpecificationCell(for: tableView)
    }
    
    var disposable: Disposable?
    
    func setupCell(_ cell: UITableViewCell) {
        guard let cell = cell as? FilterSubtitleCell else { return }
        cell.label.text = specificationType.title
        
        disposable?.dispose()
        disposable = selectedFilterObservable
            .map({ $0?.title ?? "Выбрать" })
            .bind(to: cell.subtitleLabel.rx.text)
        
    }
    
    func cellDidSelect(_ cell: UITableViewCell) {
        rowDidSelectObservable.accept(specificationType)
    }
    
}
