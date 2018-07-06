//
//  ViewController.swift
//  ChipsViewSample
//
//  Created by Masakazu Sano on 2018/07/05.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit
import Prelude
import RxSwift
import RxCocoa

final class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    fileprivate var cellFrameInfos: [ChipsCellFrameInfo] = []
    fileprivate var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
    }
}

extension ViewController {
    fileprivate func prepareCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self as? UICollectionViewDataSource
        collectionView.registerClassForCellWithType(ChipCell.self)
        
        // 各セルのwidthを事前に計算する
        cellFrameInfos = cellTitles.list.map { ChipsCellFrameInfo($0, basics: ChipsCellBasics()) }
        
        // CustomFlowLayoutのセットアップ
        let layout = CollectionViewFlowLayoutLeftAlign()
        layout.minimumInteritemSpacing = 10 // 仮で広めにマージン取る
        layout.minimumLineSpacing  = 10
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.scrollDirection = .horizontal // TODO: horizontalの場合は崩れるので、別途対応が必要
        collectionView.collectionViewLayout = layout
        
        
//        var numList: [String] = []
//        for num in 1...300 {
//            numList.append("\(num)")
//        }
//        cellFrameInfos = numList.map { ChipsCellFrameInfo($0, basics: ChipsCellBasics()) }
        
        let list = Observable.just(cellTitles.list.map{ $0 })
//        let list = Observable.just(numList.map{ $0 })
        list.bind(to: collectionView.rx.items) { collectionView, row, title in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCellWithType(ChipCell.self, forIndexPath: indexPath)
                cell.configure(title)
                return cell
            }
            .disposed(by: disposeBag)
        
        
        print("cellTitles.list.count: \(cellTitles.list.count)")
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        return cellFrameInfos[indexPath.row].frame
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("😡😡😡 tapped: \(indexPath.row)")
    }
}
