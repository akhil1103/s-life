//
//  CardView.swift
//  S-Computer
//
//  Created by balabalaji gowd yelagana on 12/09/21.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowColor: UIColor? = Constant.appColor
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var shadowRequired: Bool = true
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        if shadowRequired {
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            
            layer.masksToBounds = false
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = shadowPath.cgPath
        }
    }
}

