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
    
    fileprivate var cellFrameInfos: [ChipCellFrameInfo] = []
    fileprivate var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }
}

extension ViewController {
    fileprivate func prepareCollectionView(_ scrollDirection: UICollectionViewScrollDirection) {
        func configureCustomlayout(_ scrollDirection: UICollectionViewScrollDirection) -> UICollectionViewFlowLayout {
            let layout = CollectionViewFlowLayoutLeftAlign()
            layout.minimumInteritemSpacing = 10 // 仮で広めにマージン取る
            layout.minimumLineSpacing  = 10
            layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
            layout.scrollDirection = scrollDirection
            return layout
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self as? UICollectionViewDataSource
        collectionView.registerClassForCellWithType(ChipCell.self)
        // 各セルのframe情報をまとめる
        cellFrameInfos = cellTitles.list.map { ChipCellFrameInfo($0, basics: ChipCell.basics) }
        
        // CustomFlowLayoutのセットアップ
        collectionView.collectionViewLayout = configureCustomlayout(scrollDirection)
        
        let list = Observable.just(cellTitles.list.map{ $0 })
        list.bind(to: collectionView.rx.items) { collectionView, row, title in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCellWithType(ChipCell.self, forIndexPath: indexPath)
                cell.configure(title)
                // print("collectionView.contentSize \(collectionView.contentSize)")
                return cell
            }
            .disposed(by: disposeBag)
        // print("cellTitles.list.count: \(cellTitles.list.count)")
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

// MARK: Alert
extension ViewController {
    fileprivate func showAlert() {
        let controller = UIAlertController(title: nil, message: "Select scroll direction.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(
            title: "Horizontal",
            style: .default,
            handler: { [weak self] _ in
                guard let `self` = self else { return }
                self.prepareCollectionView(.horizontal)
            })
        )
        controller.addAction(UIAlertAction(
            title: "Vertical",
            style: .default,
            handler: { [weak self] _ in
                guard let `self` = self else { return }
                self.prepareCollectionView(.vertical)
            })
        )
        present(controller, animated: true, completion: nil)
    }
}
