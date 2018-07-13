//
//  CollectionViewDataSource.swift
//  ChipsViewSample
//
//  Created by Masakazu Sano on 2018/07/13.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    typealias Element = [String]
    var _itemModels: [String] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _itemModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let indexPath = IndexPath(row: indexPath.row, section: 0)
        let cell = collectionView.dequeueReusableCellWithType(ChipCell.self, forIndexPath: indexPath)
        cell.configure(_itemModels[indexPath.row])
        return cell
    }
}

extension CollectionViewDataSource: RxCollectionViewDataSourceType {
    func collectionView(
        _ collectionView: UICollectionView,
        observedEvent: Event<CollectionViewDataSource.Element>
        ) {
        Binder(self) { dataSource, element in
            dataSource._itemModels = element
            collectionView.reloadData()
            }
            .on(observedEvent)
    }
}

extension CollectionViewDataSource: SectionedViewDataSourceType {
    func model(at indexPath: IndexPath) throws -> Any {
        return _itemModels[indexPath.row]
    }
}
