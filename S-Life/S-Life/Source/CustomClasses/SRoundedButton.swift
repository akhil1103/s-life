//
//  SRoundedButton.swift
//  S-Life
//
//  Created by Akhil Mittal on 18/01/22.
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
