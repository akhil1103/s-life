//
//  AppManager.swift
//  S-Life
//
//  Created by Akhil Mittal on 12/02/22.
//

import Foundation
import UIKit

class AppManager {
    static func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: Constant.AppFont.bold, size: font.pointSize) ?? UIFont.systemFont(ofSize: font.pointSize)]
        let undelineAttribute : [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: Constant.appColor, NSAttributedString.Key.backgroundColor: UIColor.clear]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        attributedString.addAttributes(undelineAttribute, range: range)
        
        return attributedString
    }
}
