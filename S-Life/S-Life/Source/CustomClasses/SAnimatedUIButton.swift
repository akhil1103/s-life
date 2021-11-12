//
//  SAnimatedUIButton.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 24/08/21.
//

import UIKit

class SAnimatedUIButton: SRoundedButton {
    func performAnimation(completionOfAnimation: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { _ in
                completionOfAnimation()
            }
        }
    }
}
