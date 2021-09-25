//
//  MapViewController.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
//

import UIKit

class MapViewController: BaseViewController {

    @IBOutlet weak var topSpaceToHeaderImageCosntraint: NSLayoutConstraint!
    @IBOutlet weak var topBarHight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        topBarHight.constant = UIDevice.current.hasNotch ? 110 : 65
        topSpaceToHeaderImageCosntraint.constant = UIDevice.current.hasNotch ? 0 : 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
