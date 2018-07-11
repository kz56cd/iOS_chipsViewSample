//
//  ChipCellProtocol.swift
//  ChipsViewSample
//
//  Created by Masakazu Sano on 2018/07/11.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit

protocol ChipCellProtocol {
    static var basics: ChipCellBasics { get }
}

struct ChipCellBasics {
    var leftRightMargins: CGFloat
    var cellHeight: CGFloat
    var font: UIFont
}

struct ChipCellFrameInfo {
    let contentString: String
    let frame: CGSize
    let basics: ChipCellBasics
    
    init(_ contentString: String, basics: ChipCellBasics) {
        func calculateStringWidth(text: String, font: UIFont) -> CGFloat {
            return text.size(withAttributes: [NSAttributedStringKey.font: font]).width
        }
        
        self.contentString = contentString
        self.basics = basics
        frame = CGSize(
            width: calculateStringWidth(text: self.contentString, font: basics.font) + self.basics.leftRightMargins,
            height: basics.cellHeight
        )
    }
}
