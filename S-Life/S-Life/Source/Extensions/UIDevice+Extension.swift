//
//  UIDevice+Extension.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 21/08/21.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.windows[0].safeAreaInsets.bottom
            return bottom > 0
        } else {
            // Fallback on earlier versions
            return false
        }
       
    }
}
