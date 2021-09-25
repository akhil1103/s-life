//
//  STabBar.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
//

import UIKit

class STabBar: UITabBar {
    
    override func select(_ sender: Any?) {
        if let tabItem = sender as? UITabBarItem {
            setSelection(item: tabItem)
        }
    }
    
    func setSelection(item:UITabBarItem) {
        for i in 0..<self.items!.count {
            let ii = self.items![i]
            if(item == ii) {
                let sv = self.subviews[i+1]
                sv.backgroundColor = UIColor.red // Selection color
            } else {
                let sv = self.subviews[i+1]
                sv.backgroundColor = .gray
            }
        }
    }
}
