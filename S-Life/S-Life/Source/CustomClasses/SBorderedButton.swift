//
//  SBorderedButton.swift
//  S-Life
//
//  Created by Akhil Mittal on 25/01/22.
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
