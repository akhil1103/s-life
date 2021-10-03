//
//  Validator.swift
//  S-Life
//
//  Created by balabalaji on 18/08/21.
//

import Foundation
import Alamofire
import SystemConfiguration.CaptiveNetwork

class Validate: NSObject {
    static func email(email:String) -> Bool {
        let emailRegEx = CommonStrings.emailRegex
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func password(password:String) -> Bool {
        return password.count >= 8
    }
    
    static func check(password:String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    static func  isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
    }
    
    fileprivate static let mockWifiEnabled = false
    fileprivate static let SMC_WiFi_Name = "SMC_HotSpot"
    static func connectedToSMCHotSpot() -> Bool {
        if Validate.mockWifiEnabled {
            return true
        }
        if let wifiInfos = SSID.fetchNetworkInfo() {
            for obj in wifiInfos {
                if let wifiName = obj.ssid {
                    if wifiName == SMC_WiFi_Name {
                        return true
                    }
                }
            }
            return false
        } else {
            return false
        }
    }
}

public class SSID {
 class func fetchNetworkInfo() -> [NetworkInfo]? {
     if let interfaces: NSArray = CNCopySupportedInterfaces() {
         var networkInfos = [NetworkInfo]()
         for interface in interfaces {
             let interfaceName = interface as! String
             var networkInfo = NetworkInfo(interface: interfaceName,
                                           success: false,
                                           ssid: nil,
                                           bssid: nil)
             if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                 networkInfo.success = true
                 networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                 networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
             }
             networkInfos.append(networkInfo)
         }
         print(networkInfos)
         return networkInfos
     }
     return nil
   }
 }

struct NetworkInfo {
    var interface: String
    var success: Bool = false
    var ssid: String?
    var bssid: String?
}
