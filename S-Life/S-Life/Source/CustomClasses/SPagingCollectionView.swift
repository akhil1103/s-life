//
//  SPagingCollectionView.swift
//  S-Life
//
//  Created by Akhil Mittal on 25/01/22.
//

import UIKit

protocol SPagingCollectionViewDelegate {
    func leftSwiped()
    func rightSwiped()
}

class SPagingCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    var sPagingDelegate: SPagingCollectionViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addLeftRightSwipeGestures()
    }
    
    func addLeftRightSwipeGestures() {
        let swipeLeftGes: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        swipeLeftGes.direction = .left
        swipeLeftGes.delegate = self
        self.addGestureRecognizer(swipeLeftGes)
        
        let swipeRightGes: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        swipeRightGes.direction = .right
        swipeRightGes.delegate = self
        self.addGestureRecognizer(swipeRightGes)
    }
    
    @objc func leftSwipe() {
        self.sPagingDelegate?.leftSwiped()
    }
    
    @objc func rightSwipe() {
        self.sPagingDelegate?.rightSwiped()
    }
}
