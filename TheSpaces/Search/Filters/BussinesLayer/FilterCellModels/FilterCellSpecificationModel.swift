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
    
    let resetTrigger = PublishRelay<Void>()
    
    init(specificationType: FiltersDataSource.Sections.SpecificationsTypes) {
        self.specificationType = specificationType
        
        resetTrigger
            .mapTo(Optional<TitlePresentable>.none)
            .bind(to: selectedFilterObservable)
            .disposed(by: bag)
    }
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return FiltersViewsFactory.dequeuSpecificationCell(for: tableView)
    }
    
    private var setupBag = DisposeBag()
    
    func setupCell(_ cell: UITableViewCell) {
        guard let cell = cell as? FilterSubtitleCell else { return }
        cell.label.text = specificationType.title
        
        setupBag = DisposeBag()
        
        selectedFilterObservable
            .map({ $0?.title ?? "Выбрать" })
            .bind(to: cell.subtitleLabel.rx.text)
            .disposed(by: setupBag)
        
    }
    
    func cellDidSelect(_ cell: UITableViewCell) {
        rowDidSelectObservable.accept(specificationType)
    }
    
}
