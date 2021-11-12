//
//  SDayButton.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 21/09/21.
//

import UIKit

@IBDesignable
class SDayButton: UIButton {
    
    fileprivate let normalColor = UIColor.init(hex: "C7D1DE")
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.size.height/2
        layer.masksToBounds = true
        self.backgroundColor = normalColor
        titleLabel?.font = UIFont(name: Constant.AppFont.medium, size: 18) ?? UIFont.systemFont(ofSize: 18)
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .selected)
//        setBackgroundImage(UIImage(named: "normalDayButtonBG"), for: .normal)
//        setBackgroundImage(UIImage(named: "selectedDayButtonBG"), for: .selected)
    }
}
