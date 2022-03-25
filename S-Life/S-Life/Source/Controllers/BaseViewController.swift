//
//  BaseViewController.swift
//  S-Computer
//
//  Created by Akhil Mittal on 19/01/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController,IService {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constant.appBGColor
        // Do any additional setup after loading the view.
    }

    private var successBlock: ((String) -> ())? = nil
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func logOut() {
        
        self.showAlertWithYesOrNO(message: CommonStrings.logoutMessage) {
            self.navigationController?.popToRootViewController(animated: false)
        } noCallBack: {
            
        }

        print("LoggedOut")
        
    }
    
    func setUpNavigationLogoutButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "s-c-logout"), style: .done, target: self, action: #selector(logOut))
    }
    
    func SuccessResponse(_ json :NSObject, _ currecyId : String) {
        //
    }
    
    func ErrorResponse(_ error: NSError) {
        //
    }
    func SuccessResponse(_ json: NSArray) {
        //
    }
    
    func showAlert(message: String, okCallBack: @escaping() -> () = {}) {
        let alert = UIAlertController(title: CommonStrings.appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: CommonStrings.ok, style: .default) { (action) in
            okCallBack();
        }//UIAlertAction(title: "OK", style: .default, handl)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithYesOrNO(message: String, yesCallBack: @escaping() -> () = {}, noCallBack: @escaping() -> () = {}) {
        let alert = UIAlertController(title: CommonStrings.appName, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: CommonStrings.yes, style: .destructive) { (action) in
            yesCallBack()
        }
        let noAction = UIAlertAction(title: CommonStrings.no, style: .default) { (action) in
                noCallBack()
        }//UIAlertAction(title: "OK", style: .default, handl)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func connectedToInternet() -> Bool {
        if !Validate.isConnectedToInternet() {
            self.showAlert(message: CommonStrings.noInternetConnectionMessage)
            return false
        }
        return true
    }

}

class BaseKBViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
}
