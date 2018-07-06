//
//  ViewController.swift
//  ChipsViewSample
//
//  Created by Masakazu Sano on 2018/07/05.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit
import Prelude

final class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
    }
}

extension ViewController {
    fileprivate func prepareCollectionView() {
        collectionView.registerClassForCellWithType(ChipCell.self)
//        let layout = CollectionViewFlowLayoutLeftAlign()
//        collectionView.collectionViewLayout = layout
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTitles.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithType(ChipCell.self, forIndexPath: indexPath)
        cell.configure(cellTitles.list[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        func calcStringWidth(text: String) -> CGFloat {
            guard let font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 14) else { return 0.0 }
            return text.size(withAttributes: [NSAttributedStringKey.font: font]).width
        }
        
        return CGSize(
            width: calcStringWidth(text: cellTitles.list[indexPath.row]) + 16.0 * 2.0,
            height: 32
        )
    }
}





