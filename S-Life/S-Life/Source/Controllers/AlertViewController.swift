//
//  AlertViewController.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
//

import UIKit

class AlertViewController: BaseViewController {

    @IBOutlet weak var topBarHight: NSLayoutConstraint!
    @IBOutlet weak var topSpaceToHeaderImageCosntraint: NSLayoutConstraint!
    
    @IBOutlet weak var hotspotConnectionIndicationLabel: UILabel!
    @IBOutlet weak var notifyForHotspotConnectionView: CardView!
    @IBOutlet weak var btnConnect: SRoundedButton!
    @IBOutlet weak var btnNearestEva: SRoundedButton!
    @IBOutlet weak var noLocalAlertsView: CardView!
    @IBOutlet weak var alertsTableView: UITableView!
    
    var alertsArray = [Alert]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBarHight.constant = UIDevice.current.hasNotch ? 110 : 65
        topSpaceToHeaderImageCosntraint.constant = UIDevice.current.hasNotch ? 0 : 0
        registerTableViewCells()
        if connectedToInternet() {
            LoaderView.show()
            getSearchProjs()
        }
        // Do any additional setup after loading the view.
    }
    
    fileprivate func registerTableViewCells() {
        let nib = UINib(nibName: Constant.reUseIds.alertCellID, bundle: nil)
        alertsTableView.register(nib, forCellReuseIdentifier: Constant.reUseIds.alertCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Constant.appColor
            appearance.titleTextAttributes = [NSAttributedString.Key.font: Constant.appNavBarFont, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.tabBarController?.navigationController?.navigationBar.tintColor = .white
            self.tabBarController?.navigationController?.navigationBar.standardAppearance = appearance
            self.tabBarController?.navigationController?.navigationBar.scrollEdgeAppearance = self.tabBarController?.navigationController?.navigationBar.standardAppearance
        }
    }
    
    //MARK:- API CALLS
    
    fileprivate func getSearchProjs() {
        self.alertsArray.removeAll()
        APIUtils.apiUtilObj.callApi(requestUrl: Constant.base_url, method: .get, parameters: nil) { obj, responseData in
            LoaderView.hide()
            if let resPonse = obj as? [[String : Any]] {
                print("Search Project \(resPonse)")
                let jsonRes = try? JSONDecoder().decode(AlertResponse.self, from: responseData)
                if let alertRespObj = jsonRes {
                    for obj in alertRespObj {
                        self.alertsArray.append(obj)
                    }
                }
                self.alertsTableView.reloadData()
            } else {
                guard let response = obj as? [String: Any] else {
                    self.showAlert(message: CommonStrings.errorMessage)
                    return
                }
                BaseResponse.parse(response: response, result: {[weak self] (code, message, item)  in
                    if code == ResponseCode.success.rawValue {
                    } else {
                        self?.showAlert(message:message)
                    }
                })
            }
        } failure: { error in
            LoaderView.hide()
            self.showAlert(message: error.localizedDescription)
        }
    }
}

extension AlertViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.reUseIds.alertCellID) as? AlertTableViewCell {
            let alertObj = alertsArray[indexPath.row]
            cell.alertTitle.text = alertObj.title ?? ""
            cell.alertCategory.text = alertObj.category?.getAlertCatName()
            cell.alertDescLabel.text = alertObj.desc ?? ""
            return cell
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
}
