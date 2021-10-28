//
//  AlertViewController.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
//

import UIKit

class AlertViewController: BaseViewController, LocationManagerDelegate {
    
    fileprivate let topSectionConstr1HeightValue: CGFloat = 15.0
    fileprivate let topSectionConstr2HeightValue: CGFloat = 10.0
    fileprivate let topSectionConstr3HeightValue: CGFloat = 30.0
    fileprivate let topSectionConstr4HeightValue: CGFloat = 50.0
    fileprivate let topSectionConstr5HeightValue: CGFloat = 30.0
    
    fileprivate let topSectionInsideViewSpace1Value: CGFloat = 10.0
    fileprivate let topSectionInsideViewSpace2Value: CGFloat = 5.0
    fileprivate let topSectionInsideViewSpace3Value: CGFloat = 5.0
    fileprivate let topSectionInsideViewSpace4Value: CGFloat = 10.0

    @IBOutlet weak var topBarHight: NSLayoutConstraint!
    @IBOutlet weak var topSpaceToHeaderImageCosntraint: NSLayoutConstraint!
    
    @IBOutlet weak var topSectionConstr1Height: NSLayoutConstraint!
    @IBOutlet weak var topSectionConstr2Height: NSLayoutConstraint!
    @IBOutlet weak var topSectionConstr3Height: NSLayoutConstraint!
    @IBOutlet weak var topSectionConstr4Height: NSLayoutConstraint!
    @IBOutlet weak var topSectionConstr5Height: NSLayoutConstraint!
    
    @IBOutlet weak var topSectionInsideViewSpace1: NSLayoutConstraint!
    @IBOutlet weak var topSectionInsideViewSpace2: NSLayoutConstraint!
    @IBOutlet weak var topSectionInsideViewSpace3: NSLayoutConstraint!
    @IBOutlet weak var topSectionInsideViewSpace4: NSLayoutConstraint!
    
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
    @IBOutlet weak var latestAlertView: UIView!
    @IBOutlet weak var connectToWifiLabel: UILabel!
    @IBOutlet weak var topSectionCardView: CardView!
    
    
    var alertsArray = [SLifeAlert]()
    var newAlert: SLifeAlert?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToWifiLabel.text = "Please connect to \(Validate.SMC_WiFi_Name)"
        //connectToWifiLabel.text = "Please connect to the network in device settings. \n\n Settings → Wi-Fi → \(Validate.SMC_WiFi_Name)"
        self.alertsTableView.estimatedRowHeight = 88.0
        LocationManager.shared.delegate = self
        topBarHight.constant = UIDevice.current.hasNotch ? 110 : 65
        topSpaceToHeaderImageCosntraint.constant = UIDevice.current.hasNotch ? 0 : 0
        addAppBGToFGNotificationObserver()
        registerTableViewCells()
    }

    func addAppBGToFGNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWifiInfo), name: Notification.Name(Constant.NotificationIdentifier.notificationIdOnAppBGToFG), object: nil)
    }
    
    func removeAppBGToFGNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constant.NotificationIdentifier.notificationIdOnAppBGToFG), object: nil)
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
            nearestEvacuationVC?.alert = self.newAlert
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.pushViewController(nearestEvacuationVC!, animated: true)
        }
    }
    //MARK:- API CALLS
    
    fileprivate func hideLatestAlertSection() {
        self.topSectionConstr1Height.constant = 0
        self.topSectionConstr2Height.constant = 0
        self.topSectionConstr3Height.constant = 0
        self.topSectionConstr4Height.constant = 0
        self.topSectionConstr5Height.constant = 0
        self.topSectionInsideViewSpace1.constant = 0
        self.topSectionInsideViewSpace2.constant = 0
        self.topSectionInsideViewSpace3.constant = 0
        self.topSectionInsideViewSpace4.constant = 0
        
        self.noLatestAlertLabel.text = ""
        self.latestAlertDesc.text = ""
        self.latestAlertCategory.text = ""
        self.latestAlertTitleLabel.text = ""
    }
    
    fileprivate func showLatestAlertSection() {
        self.topSectionConstr1Height.constant = self.topSectionConstr1HeightValue
        self.topSectionConstr2Height.constant = self.topSectionConstr2HeightValue
        self.topSectionConstr3Height.constant = self.topSectionConstr3HeightValue
        self.topSectionConstr4Height.constant = self.topSectionConstr4HeightValue
        self.topSectionConstr5Height.constant = self.topSectionConstr5HeightValue
        self.topSectionInsideViewSpace1.constant = self.topSectionInsideViewSpace1Value
        self.topSectionInsideViewSpace2.constant = self.topSectionInsideViewSpace2Value
        self.topSectionInsideViewSpace3.constant = self.topSectionInsideViewSpace3Value
        self.topSectionInsideViewSpace4.constant = self.topSectionInsideViewSpace4Value
    }
    
    fileprivate func getAlerts() {
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
                    self.showLatestAlertSection()
                    self.latestAlertTagView.isHidden = false
                    self.noLatestAlertLabel.isHidden = true
                    self.latestAlertDesc.isHidden = false
                    self.latestAlertCategory.isHidden = false
                    self.latestAlertTitleLabel.isHidden = false
                    self.latestAlertDesc.text = newA.desc ?? ""
                    self.latestAlertCategory.text = Category(rawValue: newA.category?.intValue ?? 0)?.getAlertCatName()
                    self.latestAlertTitleLabel.text = newA.title ?? ""
                } else {
                    self.hideLatestAlertSection()
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
    
    @objc func getWifiInfo() {
        showLatestAlertSection()
        if Validate.connectedToSMCHotSpot() {
            hotspotConnectionIndicationLabel.isHidden = false
            notifyForHotspotConnectionView.isHidden = true
            btnConnect.isHidden = true
            btnNearestEva.isHidden = false
            LoaderView.show()
            getAlerts()
        } else {
            SLifeAlert.convertNewAlertsOld()
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
            nearestEvacuationVC?.alert = alertObj
            self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.pushViewController(nearestEvacuationVC!, animated: true)
        }
    }
}
