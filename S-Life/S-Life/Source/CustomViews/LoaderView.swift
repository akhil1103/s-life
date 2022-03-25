//
//  LoaderView.swift
//  S-Computer
//
//  Created by Akhil Mittal on 18/01/22.
//

import UIKit

class LoaderView: UIView {
    
    static let shared = instanceFromNib()
    var isVisble = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private class func instanceFromNib() -> LoaderView {
        let view = UINib(nibName: "LoaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoaderView
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return view
    }
    
    class func show(){
        shared.isVisble = true
        UIApplication.shared.keyWindow?.addSubview(shared);
    }
    
    class func hide(){
        if shared.isVisble{
            shared.isVisble = false
            DispatchQueue.main.async {
                shared.removeFromSuperview()
            }
        }
    }
}
