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

// NOTE:
// こちらのCollectionViewDataSourceは、sectionを利用しない場合は使用可能

// sectionを使いたい場合は以下のような対応になるとのこと
// https://stackoverflow.com/questions/39580085/rxswift-and-uicollectionview-header

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    typealias Element = [String]
    var _itemModels: [String] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _itemModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath)
        
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
