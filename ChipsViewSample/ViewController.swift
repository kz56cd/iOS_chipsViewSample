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
        
//        collectionView.rx.contentOffset
//            .subscribe(onNext: { offset in
//                print("😤 offset: \(offset)")
//            })
//            .disposed(by: disposeBag)
        
        let list = Observable.just(cellTitles.list.map{ $0 })
        list.bind(to: collectionView.rx.items) { collectionView, row, title in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCellWithType(ChipCell.self, forIndexPath: indexPath)
                cell.configure(title)
                return cell
            }
            .disposed(by: disposeBag)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("😡😡😡 tapped: \(indexPath.row)")
    }
}

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
