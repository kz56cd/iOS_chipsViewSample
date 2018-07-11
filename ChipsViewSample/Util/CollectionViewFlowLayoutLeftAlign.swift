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
    
//    var layoutAttributes02: [UICollectionViewLayoutAttributes] = []
    
//    var contentWidth: CGFloat {
//        guard let collectionView = collectionView else { return 0 }
//        return collectionView.bounds.width
//    }
    var contentWidth: CGFloat = 0
    var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.height
    }
    
//    override var collectionViewContentSize: CGSize {
//        return CGSize(width: contentWidth, height: contentHeight)
//    }
    
//    // ここで事前にレイアウト計算をした方がよいとのこと
    override func prepare() {
        super.prepare()
        
        guard layoutAttributes.isEmpty,
            let collectionView = collectionView else {
                return
        }
        
//        let columnWidth = contentWidth / CGFloat(numColumns)
//        var xOffsets = [CGFloat]()
//        for column in 0..<numColumns {
//            xOffsets.append(columnWidth * CGFloat(column))
//        }

        
        
        
        
        
        
        
        
//        guard let viewHeight = collectionView?.frame.height else { return nil }
//        let linesNum = cellLinesNumber(
//            by: currentAttributes.frame.height,
//            viewHeight: viewHeight,
//            sectionInsets: sectionInsets(at: indexPath.section),
//            minimumLineSpacing: minimumLineSpacing(at: indexPath.section)
//        )

        
        // let colmnHeight = contentHeight / CGFloat(lineNum)
        
        // sectionInsetの左端の値
//        let sectionInsetsLeft = sectionInsets(at: 0).left
//        let sectionInsetsTop = sectionInsets(at: 0).top
        
        switch self.scrollDirection {
        case .horizontal:
            
            print("collectionView.numberOfItems(inSection: 0) \(collectionView.numberOfItems(inSection: 0))")
            
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
                let columHeight = floor(collectionView.bounds.height / CGFloat(linesNum))
                
                // print("linesNum \(linesNum)")
//                print("minimumLineSpacing(at: 0) \(minimumLineSpacing(at: 0))")
                
                // guardだと回らない
                // 段数に応じ、先頭にくるセルは、x座標を左端にする
//                guard item >= linesNum else {
//                    print("item 左端に設置： \(item)")
//
////                    currentAttributes.frame.origin.x = sectionInsetsLeft
////                    layoutAttributes.append(currentAttributes)
//                    layoutAttribute.frame.size = cellSize
//                    layoutAttribute.frame.origin.x = sectionInsetsLeft
//
//                    // TODO: y座標も入れないといけない
//                    // print("(item % linesNum \(item % linesNum)")
//                    break
//                }

                if let cellPositionType = HorizontalCellPositionType.calcPosition(by: linesNum, item: item) {
                     print("\(item) -> \(cellPositionType)")
                    layoutAttribute.frame.size = cellSize
                    
                    switch cellPositionType {
                    case .leftAndTopEdges:
                        layoutAttribute.frame.origin = CGPoint(
                            x: sectionInsets(at: 0).left,
                            y: sectionInsets(at: 0).top
                        )
                    case .leftEdge, .leftAndBottomEdges:
                        layoutAttribute.frame.origin = CGPoint(
                            x: sectionInsets(at: 0).left,
                            y: floor(columHeight * CGFloat(item) + minimumLineSpacing(at: 0)) // NOTE: どうも詰まりすぎる..
                        )
                    case .topEdge:

//                        let prevIndexPath = IndexPath(row: indexPath.item - linesNum, section: indexPath.section)
//                        guard let prevFrame = layoutAttributesForItem(at: prevIndexPath)?.frame else {
//                            return nil
//                        }

//                        let prevIndexPath = IndexPath(row: item - linesNum, section: indexPath.section)
                        print("item - linesNum \(item - linesNum)")
                        
//                        let prevAttributeFrame = layoutAttributes[0].frame // 後ほど下に変更
                         let prevAttributeFrame = layoutAttributes[item - linesNum].frame
                        layoutAttribute.frame.origin = CGPoint(
                            x: prevAttributeFrame.maxX + minimumInteritemSpacing(at: 0),
                            y: sectionInsets(at: 0).top
                        )
                    case .noEdge, .bottomEdge:
//                        let prevAttributeFrame = layoutAttributes[0].frame // 後ほど下に変更
                         let prevAttributeFrame = layoutAttributes[item - linesNum].frame
                        layoutAttribute.frame.origin = CGPoint(
                            x: prevAttributeFrame.maxX + minimumInteritemSpacing(at: 0),
                            y: floor(columHeight * CGFloat(item % linesNum) + minimumLineSpacing(at: 0)) // NOTE: どうも詰まりすぎる..
                        )
                    }
                    
                    if layoutAttribute.frame.origin != CGPoint.zero { // 完成したらトル
                        layoutAttributes.append(layoutAttribute)
                    }
                }
            }
            _ = layoutAttributes.map { print($0.frame) }
            
//            let itemHeight = delegate.collectionView(collectionView, heightForItemAt: indexPath)
//            let height = itemHeight + padding * 2
//            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
//            let insetFrame = frame.insetBy(dx: padding, dy: padding)
//
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            attributes.frame = insetFrame
//            attributesArray.append(attributes)
//
//            contentHeight = max(contentHeight, frame.maxY)
//            yOffsets[column] = yOffsets[column] + height
//
//            column = column < (numColumns - 1) ? (column + 1) : 0
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
                    // print("item 左端、かつ上端： \(item)")
                    return .leftAndTopEdges
                } else if itemNum % linesNum == 0 {
                    // print("item 左端、かつ下端： \(item)")
                    return .leftAndBottomEdges
                } else {
                    // print("item 左端： \(item)")
                    return .leftEdge
                }
            } else {
                if itemNum % linesNum == 1 {
                    // print("item 左端ではない、かつ上端： \(item)")
                    return .topEdge
                } else if itemNum % linesNum == 0  {
                    // print("item 左端ではない、かつ下端： \(item)")
                    return .bottomEdge
                } else {
                    // print("item 左端ではない： \(item)")
                    return .noEdge
                }
            }
            return nil
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
        // あらかじめ決定されている表示領域内のレイアウト属性を取得
//        guard let attributes = super.layoutAttributesForElements(in: rect) else {
//            return nil
//        }
//        // layoutAttributesForItemAtIndexPath(_:)で各レイアウト属性を書き換える
//        var attributesToReturn = attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
//        for (index, attr) in attributes.enumerated() where attr.representedElementCategory == .cell {
//            attributesToReturn[index] = layoutAttributesForItem(at: attr.indexPath) ?? UICollectionViewLayoutAttributes()
//        }
//        return attributesToReturn
        
        
        // あらかじめ決定されている表示領域内のレイアウト属性を取得
//        guard let attributes = super.layoutAttributesForElements(in: rect) else {
//            return nil
//        }
        
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

//collectionViewのsectionInsetとminimumInteritemSpacingを必要とするので、
// VC内でUICollectionViewDelegateFlowLayout経由で取得
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
    
    func cellLinesNumber(by cellHight: CGFloat, viewHeight: CGFloat, sectionInsets: UIEdgeInsets, minimumLineSpacing: CGFloat) -> Int {
        let lines = (viewHeight - sectionInset.top - sectionInset.bottom + minimumLineSpacing) / (cellHight + minimumLineSpacing)
        return Int(lines)
    }
}
