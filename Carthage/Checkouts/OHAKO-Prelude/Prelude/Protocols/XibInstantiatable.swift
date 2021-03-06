//
//  XibInstantiatable.swift
//  Prelude
//
//  Created by Yoshikuni Kato on 2016/06/29.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

public protocol XibInstantiatable {
    func instantiate()
    func instantiate(isUserInteractionEnabled: Bool)
}

public extension XibInstantiatable where Self: UIView {
    func instantiate() {
        instantiate(isUserInteractionEnabled: true)
    }

    func instantiate(isUserInteractionEnabled: Bool) {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.isUserInteractionEnabled = isUserInteractionEnabled
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
