//
//  SBorderedButton.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/08/21.
//

import UIKit

@IBDesignable
class SBorderedButton: UIButton {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.borderColor = Constant.appColor.cgColor
        self.backgroundColor = .clear
    }
}
