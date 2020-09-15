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

class FilterCellCheckmarksModel<Filter: FilterCheckmarkType>: NSObject, FilterCellModelType, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let bag = DisposeBag()
    
    var contentHeightDisposable: Disposable?
    
    var filters = [Filter]()
    let selectedFiltersObservable = BehaviorRelay<Set<Filter>>(value: [])
    
    let contentSizeUpdatedObservable = PublishRelay<FilterParamsCell>()
    
    init(flags: [Filter], selectedFlags: [Filter]) {
        filters = flags
        selectedFiltersObservable.accept(Set(selectedFlags))
    }
    
    func dequeuCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: FilterParamsCell.identifier)!
    }
    
    func setupCell(_ cell: UITableViewCell) {
        let cell = cell as! FilterParamsCell
        
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        
        if #available(iOS 13.0, *) {
            return
        } else {
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
        }
        
        contentHeightDisposable?.dispose()
        contentHeightDisposable = cell.collectionView.rx
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
