//
//  CollectionViewFlowLayoutLeftAlign.swift
//  ChipsViewSample
//
//  Created by Masakazu Sano on 2018/07/06.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit

class CollectionViewFlowLayoutLeftAlign: UICollectionViewFlowLayout {
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []

    var contentWidth: CGFloat = 0
    var contentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        switch scrollDirection {
        case .horizontal:
            return CGSize(width: contentWidth, height: collectionView?.bounds.height ?? 0.0)
        case .vertical:
            return CGSize(width: collectionView?.bounds.width ?? 0.0, height: contentHeight)
        }
    }
    
    // 事前にレイアウト計算を行う
    override func prepare() {
        super.prepare()
        guard layoutAttributes.isEmpty,
            let collectionView = collectionView else {
                return
        }
        
        switch scrollDirection {
        case .horizontal:
            // print("collectionView.numberOfItems(inSection: 0) \(collectionView.numberOfItems(inSection: 0))")
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                let cellSize = sizeForItem(at: indexPath.row)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let linesNum = cellLinesNumber(
                    by: cellSize.height,
                    viewHeight: collectionView.bounds.height,
                    sectionInsets: sectionInsets(at: 0),
                    minimumLineSpacing: minimumLineSpacing(at: 0)
                )
                if let cellPositionType = HorizontalCellPositionType.calcPosition(by: linesNum, item: item) {
                    // print("\(item) -> \(cellPositionType)")
                    layoutAttribute.frame.size = cellSize
                    
                    switch cellPositionType {
                    case .leftAndTopEdges:
                        layoutAttribute.frame.origin = CGPoint(
                            x: sectionInsets(at: 0).left,
                            y: sectionInsets(at: 0).top
                        )
                    case .leftEdge, .leftAndBottomEdges:
                        // print("minimumLineSpacing(at: 0) : \(minimumLineSpacing(at: 0))")
                        // print("🛎🛎🛎 \(columHeight * CGFloat(item) + minimumLineSpacing(at: 0))")
                        
                        // 一つ前のセルframeを取得
                        let prevAttributeFrame = layoutAttributes[item - 1].frame
                        layoutAttribute.frame.origin = CGPoint(
                            x: sectionInsets(at: 0).left,
                            y: prevAttributeFrame.maxY + actualLineSpacing(at: item, linesNum: linesNum, from: collectionView.bounds.height)
                        )
                    case .topEdge:
                        // print("item - linesNum \(item - linesNum)")
                        // 左に隣接するセルframeを取得
                        let nearLeftAttributeFrame = layoutAttributes[item - linesNum].frame
                        layoutAttribute.frame.origin = CGPoint(
                            x: nearLeftAttributeFrame.maxX + minimumInteritemSpacing(at: item),
                            y: sectionInsets(at: 0).top
                        )
                    case .noEdge, .bottomEdge:
                        // 左に隣接するセルframeを取得
                        let nearLeftAttributeFrame = layoutAttributes[item - linesNum].frame
                        layoutAttribute.frame.origin = CGPoint(
                            x: nearLeftAttributeFrame.maxX + minimumInteritemSpacing(at: item),
                            y: nearLeftAttributeFrame.origin.y
                        )
                    }
                    if layoutAttribute.frame.origin != CGPoint.zero { // 完成したらトル
                        layoutAttributes.append(layoutAttribute)
                    }
                }
            }
            _ = layoutAttributes.map { print($0.frame) }
            
            // いちばん右端に位置するセルから、contentSizeのwidthを算出し、collectionViewContentSizeに反映
            self.contentWidth = layoutAttributes
                .map { return $0.frame.origin.x + $0.frame.width + minimumInteritemSpacing(at: 0) }
                .max() ?? 0.0
            // print("contentWidth: \(contentWidth)")
        case .vertical:
            print("未対応")
        }
        
    }
    
    enum HorizontalCellPositionType {
        case leftAndTopEdges
        case leftEdge
        case leftAndBottomEdges
        case topEdge
        case noEdge
        case bottomEdge
        
        static func calcPosition(by linesNum: Int, item: Int) -> HorizontalCellPositionType? {
            let itemNum = item + 1
            
            if itemNum <= linesNum { // 左端の場合
                if itemNum == 1 {
                    return .leftAndTopEdges
                } else if itemNum % linesNum == 0 {
                    return .leftAndBottomEdges
                } else {
                    return .leftEdge
                }
            } else {
                if itemNum % linesNum == 1 {
                    return .topEdge
                } else if itemNum % linesNum == 0  {
                    return .bottomEdge
                } else {
                    return .noEdge
                }
            }
        }
    }
    
//    switch self.scrollDirection {
//    case .horizontal:
//
//
//    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
//
//    layoutAttributes.map { $0.frame.intersects(rext) }
//
//    //            for attributes in attributesArray {
//    //                if attributes.frame.intersects(rect) {
//    //                    visibleLayoutAttributes.append(attributes)
//    //                }
//    //            }
//    //            return visibleLayoutAttributes
//
//
//    return currentAttributes
//    case .vertical:
//    print("まだ未対応です")
//    return UICollectionViewLayoutAttributes(forCellWith: indexPath)
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        
        switch self.scrollDirection {
        case .horizontal:
           return layoutAttributes
                .filter { $0.frame.intersects(rect) }
                .map { return $0 }
        case .vertical:
            print("まだ未対応です")
            return nil
        }
    }

    
    
// ----------------------------------------------------------------------
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        // あらかじめ決定されている表示領域内のレイアウト属性を取得
//        guard let attributes = super.layoutAttributesForElements(in: rect) else {
//            return nil
//        }
//        // layoutAttributesForItemAtIndexPath(_:)で各レイアウト属性を書き換える
//        var attributesToReturn = attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
//        for (index, attr) in attributes.enumerated() where attr.representedElementCategory == .cell {
//            attributesToReturn[index] = layoutAttributesForItem(at: attr.indexPath) ?? UICollectionViewLayoutAttributes()
//        }
//        return attributesToReturn
//    }
    
    //layoutAttributesForItemAtIndexPath
    // 各セルのレイアウト属性の補正
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let currentAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
//        // print("currentAttributes \(currentAttributes)")
//
//        switch self.scrollDirection {
//        case .horizontal:
//            // print("=========================================================")
//            // print("row: \(indexPath.row)")
//
//            //            print("🎈 indexPath.section \(indexPath.section)")
//
////            if layoutAttributes02.count >= indexPath.row + 1 {
//            if layoutAttributes.count >= indexPath.row + 1 {
////                return layoutAttributes02[indexPath.row]
//                return layoutAttributes[indexPath.row]
//            }
//
//            guard let viewHeight = collectionView?.frame.height else { return nil }
//            let linesNum = cellLinesNumber(
//                by: currentAttributes.frame.height,
//                viewHeight: viewHeight,
//                sectionInsets: sectionInsets(at: indexPath.section),
//                minimumLineSpacing: minimumLineSpacing(at: indexPath.section)
//            )
//            //            print("linesNum: \(linesNum)")
//
//            // sectionInsetの左端の値
//            let sectionInsetsLeft = sectionInsets(at: indexPath.section).left
//
//            // 段数に応じ、先頭にくるセルは、x座標を左端にする
//            guard indexPath.item >= linesNum else {
//                currentAttributes.frame.origin.x = sectionInsetsLeft
////                layoutAttributes02.append(currentAttributes)
//                layoutAttributes.append(currentAttributes)
//                return currentAttributes
//            }
//
//            // 左に隣接するセルを取得
//            let prevIndexPath = IndexPath(row: indexPath.item - linesNum, section: indexPath.section)
//            guard let prevFrame = layoutAttributesForItem(at: prevIndexPath)?.frame else {
//                return nil
//            }
//            //            print("💛 prevFrame: \(prevFrame)")
//
//            // 左に隣接するセルの、末尾のx座標を取得
//            let prevItemTailX = prevFrame.origin.x + prevFrame.width
//            currentAttributes.frame.origin.x = prevItemTailX + minimumInteritemSpacing(at: indexPath.section)
//            //             print("💜💜 currentAttributes.frame.origin.x (2回目): \(currentAttributes.frame.origin.x)")
//            //             print("\n")
//
////            layoutAttributes02.append(currentAttributes)
//            layoutAttributes.append(currentAttributes)
//
//
//
//
//            // テスト用
////            if indexPath.row == 72 {
////                print("🎈")
////                 _ = layoutAttributes02.map { print($0.frame) }
////            }
//
//            return currentAttributes
//        case .vertical:
//            // print("=========================================================")
//            // print("row: \(indexPath.row)")
//            // print("🐱 viewWidth: \(viewWidth)")
//
//            guard let viewWidth = collectionView?.frame.width else { return nil }
//            // sectionInsetの左端の値
//            let sectionInsetsLeft = sectionInsets(at: indexPath.section).left
//
//            // 先頭セルの場合はx座標を左端にして返す
//            guard indexPath.item > 0 else {
//                currentAttributes.frame.origin.x = sectionInsetsLeft
//                return currentAttributes
//            }
//            // print("💜 currentAttributes.frame.origin.x (1回目): \(currentAttributes.frame.origin.x)")
//
//            // ひとつ前のセルを取得
//            let prevIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
//            guard let prevFrame = layoutAttributesForItem(at: prevIndexPath)?.frame else {
//                return nil
//            }
//            // print("💛 prevFrame: \(prevFrame)")
//
//            // 現在のセルの行内にひとつ前のセルが収まっているか比較
//            let validWidth = viewWidth - sectionInset.left - sectionInset.right
//            // print("💛 validWidth: \(validWidth)")
//            let currentColumnRect = CGRect(x: sectionInsetsLeft, y: currentAttributes.frame.origin.y, width: validWidth, height: currentAttributes.frame.height)
//            guard prevFrame.intersects(currentColumnRect) else { // 収まっていない場合
//                currentAttributes.frame.origin.x = sectionInsetsLeft // x座標を左端にして返す
//                return currentAttributes
//            }
//
//            let prevItemTailX = prevFrame.origin.x + prevFrame.width
//            currentAttributes.frame.origin.x = prevItemTailX + minimumInteritemSpacing(at: indexPath.section)
//            // print("💜💜 currentAttributes.frame.origin.x (2回目): \(currentAttributes.frame.origin.x)")
//            // print("\n")
//            return currentAttributes
//        }
//    }
    
// ----------------------------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
    //layoutAttributesForItemAtIndexPath
    // 各セルのレイアウト属性の補正
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let currentAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
//
//
//        // print("currentAttributes \(currentAttributes)")
//
//        switch self.scrollDirection {
//        case .horizontal:
//            // print("=========================================================")
//            // print("row: \(indexPath.row)")
//
////            print("🎈 indexPath.section \(indexPath.section)")
//
//            if layoutAttributes.count >= indexPath.row + 1 {
//                // print("layoutAttributes.count: \(layoutAttributes.count)")
//                return layoutAttributes[indexPath.row]
//            }
//
//            guard let viewHeight = collectionView?.frame.height else { return nil }
//            let linesNum = cellLinesNumber(
//                by: currentAttributes.frame.height,
//                viewHeight: viewHeight,
//                sectionInsets: sectionInsets(at: indexPath.section),
//                minimumLineSpacing: minimumLineSpacing(at: indexPath.section)
//            )
////            print("linesNum: \(linesNum)")
//
//            // sectionInsetの左端の値
//            let sectionInsetsLeft = sectionInsets(at: indexPath.section).left
//
//            // 段数に応じ、先頭にくるセルは、x座標を左端にする
//            guard indexPath.item >= linesNum else {
//                currentAttributes.frame.origin.x = sectionInsetsLeft
//                layoutAttributes.append(currentAttributes)
//                return currentAttributes
//            }
//
//            // 左に隣接するセルを取得
//            let prevIndexPath = IndexPath(row: indexPath.item - linesNum, section: indexPath.section)
//            guard let prevFrame = layoutAttributesForItem(at: prevIndexPath)?.frame else {
//                return nil
//            }
////            print("💛 prevFrame: \(prevFrame)")
//
//            // 左に隣接するセルの、末尾のx座標を取得
//            let prevItemTailX = prevFrame.origin.x + prevFrame.width
//            currentAttributes.frame.origin.x = prevItemTailX + minimumInteritemSpacing(at: indexPath.section)
////             print("💜💜 currentAttributes.frame.origin.x (2回目): \(currentAttributes.frame.origin.x)")
////             print("\n")
//            layoutAttributes.append(currentAttributes)
//            return currentAttributes
//        case .vertical:
//            // print("=========================================================")
//            // print("row: \(indexPath.row)")
//            // print("🐱 viewWidth: \(viewWidth)")
//
//            guard let viewWidth = collectionView?.frame.width else { return nil }
//            // sectionInsetの左端の値
//            let sectionInsetsLeft = sectionInsets(at: indexPath.section).left
//
//            // 先頭セルの場合はx座標を左端にして返す
//            guard indexPath.item > 0 else {
//                currentAttributes.frame.origin.x = sectionInsetsLeft
//                return currentAttributes
//            }
//            // print("💜 currentAttributes.frame.origin.x (1回目): \(currentAttributes.frame.origin.x)")
//
//            // ひとつ前のセルを取得
//            let prevIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
//            guard let prevFrame = layoutAttributesForItem(at: prevIndexPath)?.frame else {
//                return nil
//            }
//            // print("💛 prevFrame: \(prevFrame)")
//
//            // 現在のセルの行内にひとつ前のセルが収まっているか比較
//            let validWidth = viewWidth - sectionInset.left - sectionInset.right
//            // print("💛 validWidth: \(validWidth)")
//            let currentColumnRect = CGRect(x: sectionInsetsLeft, y: currentAttributes.frame.origin.y, width: validWidth, height: currentAttributes.frame.height)
//            guard prevFrame.intersects(currentColumnRect) else { // 収まっていない場合
//                currentAttributes.frame.origin.x = sectionInsetsLeft // x座標を左端にして返す
//                return currentAttributes
//            }
//
//            let prevItemTailX = prevFrame.origin.x + prevFrame.width
//            currentAttributes.frame.origin.x = prevItemTailX + minimumInteritemSpacing(at: indexPath.section)
//            // print("💜💜 currentAttributes.frame.origin.x (2回目): \(currentAttributes.frame.origin.x)")
//            // print("\n")
//            return currentAttributes
//        }
//    }
}

// UICollectionViewDelegateFlowLayoutを継承
extension CollectionViewFlowLayoutLeftAlign {
    fileprivate func sizeForItem(at index: Int) -> CGSize {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
                return self.sizeForItem(at: 0)
        }
        return delegate.collectionView?(collectionView, layout: self, sizeForItemAt: IndexPath(row: index, section: 0)) ?? self.sizeForItem(at: 0)
    }
    
    fileprivate func sectionInsets(at index: Int) -> UIEdgeInsets {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
                return self.sectionInset
        }
        return delegate.collectionView?(collectionView, layout: self, insetForSectionAt: index) ?? self.sectionInset
    }
    
    fileprivate func minimumInteritemSpacing(at index: Int) -> CGFloat {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
                return self.minimumInteritemSpacing
        }
        return delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: index) ?? self.minimumInteritemSpacing
    }
    
    fileprivate func minimumLineSpacing(at index: Int) -> CGFloat {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
                return self.minimumLineSpacing
        }
        return delegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: index) ?? self.minimumLineSpacing
    }
}
    
extension CollectionViewFlowLayoutLeftAlign {
    fileprivate func cellLinesNumber(by cellHight: CGFloat, viewHeight: CGFloat, sectionInsets: UIEdgeInsets, minimumLineSpacing: CGFloat) -> Int {
        let lines = (viewHeight - sectionInset.top - sectionInset.bottom + minimumLineSpacing) / (cellHight + minimumLineSpacing)
        return Int(lines)
    }
    
    // 実際の列ごとのマージンの取得
    // （contentSize.heightによって、minimumLineSpacingよりも大きな値になるため、事前計算用に用意している)
    fileprivate func actualLineSpacing(at index: Int, linesNum: Int, from viewHeight: CGFloat) -> CGFloat {
        let viewHeightWithoutPadding = viewHeight - sectionInsets(at: 0).top - sectionInsets(at: 0).bottom
        let actualSpacing = (viewHeightWithoutPadding - CGFloat(linesNum) * sizeForItem(at: index).height) / CGFloat(linesNum - 1)
        let minimumSpacing = minimumLineSpacing(at: index)
        return actualSpacing > minimumSpacing ? actualSpacing : minimumSpacing
    }
}
