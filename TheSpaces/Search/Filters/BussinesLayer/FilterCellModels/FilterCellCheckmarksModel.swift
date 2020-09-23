//
//  FilterCellCheckmarksModel.swift
//  TheSpaces
//
//  Created by Денис Швыров on 10.09.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FilterCellCheckmarksModel<Filter: FilterCheckmarkType>: NSObject, TableCellModelType, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let bag = DisposeBag()
    
    var filters: [Filter]
    let selectedFiltersObservable = BehaviorRelay<Set<Filter>>(value: [])
    
    let contentSizeUpdatedObservable = PublishRelay<FilterParamsCell>()
    let resetTrigger = PublishRelay<Void>()
    
    init(flags: [Filter], selectedFlags: [Filter]) {
        filters = flags
        selectedFiltersObservable.accept(Set(selectedFlags))
    }
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: FilterParamsCell.identifier)!
    }
    
    private var setupBag = DisposeBag()
    
    func setupCell(_ cell: UITableViewCell) {
        let cell = cell as! FilterParamsCell
        
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        
        if #available(iOS 13.0, *) {} else {
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
        }
        
        setupBag = DisposeBag()
        
        cell.collectionView.rx
            .observe(CGSize.self, #keyPath(UICollectionView.contentSize))
            .filterNil()
            .map({[weak cell] _ in return cell })
            .filterNil()
            .filter({ (cell) -> Bool in
                cell.collectionViewHeightConstr.constant != cell.collectionView.contentSize.height
            })
            .do(onNext: { (cell) in
                cell.collectionViewHeightConstr.constant = cell.collectionView.contentSize.height
            })
            .bind(to: contentSizeUpdatedObservable)
            .disposed(by: setupBag)
        
        resetTrigger
            .subscribe {[unowned self, unowned cell] _ in
                self.selectedFiltersObservable.accept([])
                
                for index in 0 ..< filters.count {
                    guard let checkmarkCell = cell.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CheckmarkCell else { continue }
                    checkmarkCell.checkButton.isSelected = false
                }
                
            }
            .disposed(by: setupBag)
        
    }
    
    func cellWillApear(_ cell: UITableViewCell) {
        
    }
    
    //MARK: - CollectionView dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { filters.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckmarkCell.identifier, for: indexPath) as! CheckmarkCell
        
        let filter = filters[indexPath.row]
        cell.checkButton.label.text = filter.title
        let selectedFilters = selectedFiltersObservable.value
        cell.checkButton.isSelected = selectedFilters.contains(filter)
        
        if !cell.checkButton.constraints.contains(where: {$0.firstAttribute == .width}) {
            cell.checkButton.widthAnchor.constraint(equalToConstant: collectionView.bounds.width / 2).isActive = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! CheckmarkCell
        var selectedFilters = selectedFiltersObservable.value
        
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
            cell.checkButton.isSelected = false
        } else {
            selectedFilters.insert(filter)
            cell.checkButton.isSelected = true
        }
        
        selectedFiltersObservable.accept(selectedFilters)
    }
}
