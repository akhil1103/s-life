//
//  CommonStrings.swift
//  S-Life
//
//  Created by Akhil Mittal on 18/01/22.
//

import Foundation
struct CommonStrings {
    static let appName = "S-Life"
    internal static var emailRegex = "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
    static let errorMessage = "Something went wrong"
    static let logoutMessage = "Are you sure you want to log out?"
    static let noInternetConnectionMessage = "Seems Internet connection is not available"
    static let wifiToggleTurnedOff = "wifi toggle Turned Off"
    static let locationPermissionAlert = "Location access is required to access wifi information"
    static let noNewAlerts = "S-Life try to keep you safe when in a Disaster situation"
    static let yes = "Yes"
    static let no = "NO"
    static let ok = "OK"
}
