//
//  ChipCell.swift
//  ChipsViewSample
//
//  Created by Masakazu Sano on 2018/07/05.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit
import Prelude

final class ChipCell: UICollectionViewCell, ChipCellProtocol, XibInstantiatable {
    @IBOutlet weak var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        instantiate(isUserInteractionEnabled: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instantiate(isUserInteractionEnabled: false)
    }
}

extension ChipCell {
    func configure(_ title: String) {
        textLabel.text = title
    }
    
    static var basics: ChipCellBasics {
        // NOTE: frame計算用の値を事前にセットしておく
        return ChipCellBasics(
            leftRightMargins: 32.0,
            cellHeight: 32.0,
            font: UIFont(name: "Hiragino Kaku Gothic ProN", size: 14)!
        )
    }
}
