//
//  Validator.swift
//  S-Life
//
//  Created by balabalaji on 18/08/21.
//

import Foundation
import Alamofire
class Validate {
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
}
