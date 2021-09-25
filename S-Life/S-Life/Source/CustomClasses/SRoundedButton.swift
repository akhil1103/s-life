//
//  SRoundedButton.swift
//  S-Life
//
//  Created by balabalaji on 18/08/21.
//

import UIKit

@IBDesignable
class SRoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 2
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
