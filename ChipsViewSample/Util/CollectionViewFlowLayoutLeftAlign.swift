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
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let cellSize = sizeForItem(at: indexPath.row)
            let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttribute.frame.size = cellSize
            
            let linesNum = cellLinesNumber(
                by: cellSize.height,
                viewHeight: collectionView.bounds.height,
                sectionInsets: sectionInsets(at: 0),
                minimumLineSpacing: minimumLineSpacing(at: 0)
            )
        
            switch scrollDirection {
            case .horizontal:
                guard let cellPosition = HorizontalCellPositionType.calcPosition(by: linesNum, item: item) else { return }
                
                switch cellPosition {
                case .leftAndTopEdges:
                    layoutAttribute.frame.origin = CGPoint(
                        x: sectionInsets(at: 0).left,
                        y: sectionInsets(at: 0).top
                    )
                case .leftEdge, .leftAndBottomEdges:
                    // 一つ前のセルframeを取得
                    let prevAttributeFrame = layoutAttributes[item - 1].frame
                    layoutAttribute.frame.origin = CGPoint(
                        x: sectionInsets(at: 0).left,
                        y: prevAttributeFrame.maxY + actualLineSpacing(at: item, linesNum: linesNum, from: collectionView.bounds.height)
                    )
                case .topEdge:
                    // 左に隣接するcell frameを取得
                    let nearLeftAttributeFrame = layoutAttributes[item - linesNum].frame
                    layoutAttribute.frame.origin = CGPoint(
                        x: nearLeftAttributeFrame.maxX + minimumInteritemSpacing(at: 0),
                        y: sectionInsets(at: 0).top
                    )
                case .noEdge, .bottomEdge:
                    // 左に隣接するcell frameを取得
                    let nearLeftAttributeFrame = layoutAttributes[item - linesNum].frame
                    layoutAttribute.frame.origin = CGPoint(
                        x: nearLeftAttributeFrame.maxX + minimumInteritemSpacing(at: 0),
                        y: nearLeftAttributeFrame.origin.y
                    )
                }
                layoutAttributes.append(layoutAttribute)
            
            case .vertical:
                guard item > 0 else {
                    // 配置座標の決定 (ケース1):
                    // 左端 / 上端に配置
                    layoutAttribute.frame.origin = CGPoint(
                        x: sectionInsets(at: item).left,
                        y: sectionInsets(at: item).top
                    )
                    layoutAttributes.append(layoutAttribute)
                    continue
                }
                // ひとつ前のcell frameを取得
                let prevAttributeFrame = layoutAttributes[item - 1].frame
                
                // 一つ前のセルの右隣に設置した場合のx, y座標を指定
                layoutAttribute.frame.origin = CGPoint(
                    x: prevAttributeFrame.maxX + minimumInteritemSpacing(at: indexPath.section),
                    y: prevAttributeFrame.origin.y
                )
                let contentMaxX = collectionView.frame.width - sectionInsets(at: item).right
                
                // 右隣に設置した際に、content内に収まるか鑑定
                guard contentMaxX > layoutAttribute.frame.maxX else {
                    // 配置座標の決定 (ケース2):
                    // 行内に収まらないため、x, y座標を更新（ = 改行し、かつx座標を左端に指定）
                    layoutAttribute.frame.origin = CGPoint(
                        x: sectionInsets(at: item).left,
                        y: prevAttributeFrame.maxY + actualLineSpacing(at: item, linesNum: linesNum, from: contentHeight)
                    )
                    layoutAttributes.append(layoutAttribute)
                    continue
                }
                // 配置座標の決定 (ケース3):
                // 一つ前のセルの右隣に設置
                layoutAttributes.append(layoutAttribute)
            }
        }
        // _ = layoutAttributes.map { print($0.frame) }
        
        switch scrollDirection {
        case .horizontal:
            // いちばん右端に位置するセルから、contentSizeのwidthを算出し、collectionViewContentSizeに反映
            self.contentWidth = layoutAttributes
                .map { return $0.frame.maxX + sectionInsets(at: 0).right }
                .max() ?? 0.0
        case .vertical:
            // contentHeightを決定
            self.contentHeight = layoutAttributes
                .map { return $0.frame.maxY + sectionInsets(at: 0).bottom }
                .max() ?? 0.0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        
        switch self.scrollDirection {
        case .horizontal:
            return layoutAttributes
                .filter { $0.frame.intersects(rect) }
                .map { return $0 }
        case .vertical:
            return layoutAttributes
                .filter { $0.frame.intersects(rect) }
                .map { return $0 }
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
        let minimumSpacing = minimumLineSpacing(at: 0)
        return actualSpacing > minimumSpacing ? actualSpacing : minimumSpacing
    }
}
