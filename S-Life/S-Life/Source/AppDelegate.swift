//
//  AppDelegate.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 02/08/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(2)
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.tintColor = .white
        ModelManager.sharedInstance.createContainer()
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let xcDataModelName = "S-Life"
        let container = NSPersistentContainer(name: xcDataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {

                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(Constant.NotificationIdentifier.notificationIdOnAppBGToFG), object: nil)
    }
}

