//
//  AlertViewController.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
//

import UIKit

class AlertViewController: BaseViewController, LocationManagerDelegate {

    @IBOutlet weak var topBarHight: NSLayoutConstraint!
    @IBOutlet weak var topSpaceToHeaderImageCosntraint: NSLayoutConstraint!
    
    @IBOutlet weak var hotspotConnectionIndicationLabel: UILabel!
    @IBOutlet weak var notifyForHotspotConnectionView: CardView!
    @IBOutlet weak var btnConnect: SRoundedButton!
    @IBOutlet weak var btnNearestEva: SRoundedButton!
    @IBOutlet weak var noLocalAlertsView: CardView!
    @IBOutlet weak var localAlertMainView: UIView!
    @IBOutlet weak var latestAlertTagView: UIView!
    @IBOutlet weak var alertsTableView: UITableView!
    @IBOutlet weak var latestAlertTitleLabel: UILabel!
    @IBOutlet weak var latestAlertCategory: UILabel!
    @IBOutlet weak var latestAlertDesc: UILabel!
    @IBOutlet weak var noLatestAlertLabel: UILabel!
    
    var alertsArray = [SLifeAlert]()
    var newAlert: SLifeAlert?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertsTableView.estimatedRowHeight = 88.0
        LocationManager.shared.delegate = self
        topBarHight.constant = UIDevice.current.hasNotch ? 110 : 65
        topSpaceToHeaderImageCosntraint.constant = UIDevice.current.hasNotch ? 0 : 0
        
        registerTableViewCells()
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
        LocationManager.shared.requestLocationAuthorization()
        getWifiInfo()
    }
    
    @IBAction func connectButtonTapped(_ sender: Any) {
//        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//        }
        let url = URL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared
        app.open(url!)
    }
    
    @IBAction func nearestEvacuationBtnTapped(_ sender: Any) {
        DispatchQueue.main.async {
            let nearestEvacuationVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryboardIDs.nearestEvacuationVC) as? NearestEvacuationVC
            nearestEvacuationVC?.location = Location(lat: self.newAlert?.lat?.doubleValue, long: self.newAlert?.long?.doubleValue)
            self.navigationController?.pushViewController(nearestEvacuationVC!, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
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
                    SLifeAlert.processAndGetAlertResponse(response: alertRespObj)
                }
                self.newAlert = SLifeAlert.getNew()
                if let newA = self.newAlert {
                    self.latestAlertTagView.isHidden = false
                    self.noLatestAlertLabel.isHidden = true
                    self.latestAlertDesc.isHidden = false
                    self.latestAlertCategory.isHidden = false
                    self.latestAlertTitleLabel.isHidden = false
                    self.latestAlertDesc.text = newA.desc ?? ""
                    self.latestAlertCategory.text = Category(rawValue: newA.category?.intValue ?? 0)?.getAlertCatName()
                    self.latestAlertTitleLabel.text = newA.title ?? ""
                } else {
                    self.latestAlertTagView.isHidden = true
                    self.noLatestAlertLabel.isHidden = false
                    self.latestAlertDesc.isHidden = true
                    self.latestAlertCategory.isHidden = true
                    self.latestAlertTitleLabel.isHidden = true
                }
                self.alertsArray = SLifeAlert.getOldAlerts()
                self.setUpView()
            } else {
                self.alertsArray = SLifeAlert.getOldAlerts()
                self.setUpView()
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
            self.alertsArray = SLifeAlert.getOldAlerts()
            self.setUpView()
            LoaderView.hide()
            self.showAlert(message: error.localizedDescription)
        }
    }
    
    func getWifiInfo() {
        if Validate.connectedToSMCHotSpot() {
            hotspotConnectionIndicationLabel.isHidden = false
            notifyForHotspotConnectionView.isHidden = true
            btnConnect.isHidden = true
            btnNearestEva.isHidden = false
            LoaderView.show()
            getSearchProjs()
        } else {
            hotspotConnectionIndicationLabel.isHidden = true
            notifyForHotspotConnectionView.isHidden = false
            btnConnect.isHidden = false
            btnNearestEva.isHidden = true
            self.alertsArray = SLifeAlert.getOldAlerts()
            setUpView()
        }
    }
    
    func setUpView() {
        if self.alertsArray.count == 0 {
            self.noLocalAlertsView.isHidden = false
            self.localAlertMainView.isHidden = true
        } else {
            self.noLocalAlertsView.isHidden = true
            self.localAlertMainView.isHidden = false
            self.alertsTableView.reloadData()
        }
    }
    
    func showLocationPermissionRequiredAlert() {
        showAlert(message: CommonStrings.locationPermissionAlert) {
            LocationManager.shared.requestLocationAuthorization()
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
            cell.alertCategory.text = Category(rawValue: alertObj.category?.intValue ?? 0)?.getAlertCatName()
            cell.alertDescLabel.text = alertObj.desc ?? ""
            cell.btnLocation.tag = indexPath.row
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension AlertViewController: AlertTableViewCellDelegate {
    func locationBtnTapped(atRow: Int) {
        let alertObj = alertsArray[atRow]
        DispatchQueue.main.async {
            let nearestEvacuationVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.StoryboardIDs.nearestEvacuationVC) as? NearestEvacuationVC
            nearestEvacuationVC?.location = Location(lat: alertObj.lat?.doubleValue, long: alertObj.long?.doubleValue)
            self.navigationController?.pushViewController(nearestEvacuationVC!, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}
