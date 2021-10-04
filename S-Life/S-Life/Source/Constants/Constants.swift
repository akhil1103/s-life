//
//  Constants.swift
//  S-Life
//
//  Created by balabalaji on 18/08/21.
//

import Foundation
import UIKit

class Constant {
    static let base_url = "http://167.71.238.109:4400"
    
    static let appNavBarFont = UIFont(name: Constant.AppFont.regular, size: 20)!
    
    struct AppFont {
        static let regular = "Montserrat-Regular"
        static let bold = "Montserrat-Bold"
        static let light = "Montserrat-Light"
        static let medium = "Montserrat-Medium"
        static let xtraLight = "Montserrat-ExtraLight"
        static let semiBold = "Montserrat-SemiBold"
        static let thin = "Montserrat-Thin"
    }
    
    static let appColor = UIColor(red: 24.0/255.0, green: 51.0/255.0, blue: 90.0/255.0, alpha: 1)
    static let appBGColor = UIColor.init(hex: "DBE5F1")
    
    struct Segue {
        
    }
    
    struct reUseIds {
        static let alertCellID = "AlertTableViewCell"
    }
    
    struct StoryboardIDs {
        static let nearestEvacuationVC = "NearestEvacuationVC"
    }
    
    struct NotificationIdentifier {
        static let notificationIdOnAppBGToFG = "CheckForWifiOnAppBackgroundToForeGround"
    }
    
    static let placeHolderProjImage = UIImage(named: "s-c-home-image-placeholder")
}

enum ResponseCode:String {
    case error
    case success
}

struct API {

}

struct User {
}
