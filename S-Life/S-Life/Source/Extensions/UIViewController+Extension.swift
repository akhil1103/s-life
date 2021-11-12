//
//  UIViewController+Extension.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 19/08/21.
//

import Foundation
import UIKit

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let scrollUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        scrollUp.direction = .up
        view.addGestureRecognizer(scrollUp)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
