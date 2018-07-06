//
//  ChipCell.swift
//  ChipsViewSample
//
//  Created by Masakazu Sano on 2018/07/05.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit
import Prelude

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
