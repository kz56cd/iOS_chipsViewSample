//
//  ChipCell.swift
//  ChipsViewSample
//
//  Created by Masakazu Sano on 2018/07/05.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit
import Prelude

// NOTE: frame計算用の値。事前にセットしておく
struct ChipsCellBasics {
    let leftRightMargins: CGFloat = 32.0
    let cellHeight: CGFloat = 32.0
    let font: UIFont = UIFont(name: "Hiragino Kaku Gothic ProN", size: 14)!
}

final class ChipCell: UICollectionViewCell, XibInstantiatable {
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
}

struct ChipsCellFrameInfo {
    let contentString: String
    let frame: CGSize
    let leftRightMargins: CGFloat
    let stringWidth: CGFloat
    
    init(_ contentString: String, basics: ChipsCellBasics) {
        func calculateStringWidth(text: String, font: UIFont) -> CGFloat {
            return text.size(withAttributes: [NSAttributedStringKey.font: font]).width
        }
        
        self.contentString = contentString
        self.leftRightMargins = basics.leftRightMargins
        stringWidth = calculateStringWidth(
            text: self.contentString,
            font: basics.font
        )
        frame = CGSize(width: stringWidth + leftRightMargins, height: basics.cellHeight)
    }
}

