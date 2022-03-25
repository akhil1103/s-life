//
//  STabBar.swift
//  S-Life
//
//  Created by Akhil Mittal on 25/02/22.
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
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    private func addShape() {
        
        self.layer.masksToBounds = true
        self.isTranslucent = true
        self.barStyle = .black
        
        self.layer.masksToBounds = true
        
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: Constant.AppFont.regular, size: 10)!], for: .normal)
        appearance.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: Constant.AppFont.regular, size: 10)!], for: .selected)
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -12)
        
        for (_,tabBarItem) in self.items!.enumerated() {
            tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: Constant.AppFont.regular, size: 12)!], for: .normal)
            tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: Constant.AppFont.regular, size: 12)!], for: .selected)
        }
    }
    
}
