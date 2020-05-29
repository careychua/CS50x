//
//  Button.swift
//  Fiftygram
//
//  Created by Carey Chua on 14/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

