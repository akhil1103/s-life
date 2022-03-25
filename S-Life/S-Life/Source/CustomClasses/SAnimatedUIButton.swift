//
//  SAnimatedUIButton.swift
//  S-Life
//
//  Created by Akhil Mittal on 24/01/22.
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
