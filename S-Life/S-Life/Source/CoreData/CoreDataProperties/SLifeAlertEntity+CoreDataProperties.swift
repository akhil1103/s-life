//
//  SLifeAlertEntity+CoreDataProperties.swift
//  S-Life
//
//  Created by balabalaji on 03/10/21.
//

import Foundation
import CoreData

extension SLifeAlert {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SLifeAlert> {
        return NSFetchRequest<SLifeAlert>(entityName: "SLifeAlert")
    }
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var category: NSNumber?
    @NSManaged public var lat: NSNumber?
    @NSManaged public var long: NSNumber?
    @NSManaged public var isNew: NSNumber?
    
    fileprivate static var latestAlert: SLifeAlert?
    
    fileprivate static func add(_ obj: Alert) {
        let alertObj = DataAccess.sharedInstance.createObject() as SLifeAlert
        alertObj.id = obj.id
        alertObj.title = obj.title
        alertObj.desc = obj.desc
        alertObj.category = NSNumber(value: obj.category?.rawValue ?? 0)
        alertObj.date = obj.date
        alertObj.lat = NSNumber(value: obj.location?.lat ?? 0.0)
        alertObj.long = NSNumber(value: obj.location?.long ?? 0.0)
        alertObj.isNew = true
    }
    
    static func processAndGetAlertResponse(response: AlertResponse) {
        convertNewAlertsOld()
        for obj in response {
            if let id = obj.id, let alert = DataAccess.sharedInstance.getObjectWithLocalId(id) as SLifeAlert? {
                _ = DataAccess.sharedInstance.deleteObject(alert)
                add(obj)
                print("\(id) existed")
                continue
            } else {
                add(obj)
                print("\(String(describing: obj.id)) created")
            }
        }
        _ = DataAccess.sharedInstance.saveContextWithID()
        setNew()
    }
    
    static func getOldAlerts() -> [SLifeAlert] {
        let alerts = DataAccess.sharedInstance.getObjects(.none) as [SLifeAlert]
        let oldAlerts = alerts.filter { obj in
            return (obj.isNew?.boolValue ?? false == false)
        }
        let sortedOldAlerts = oldAlerts.sorted(by: { $0.date ?? "" > $1.date ?? "" })
        return sortedOldAlerts
    }
    
    static func getNew() -> SLifeAlert? {
        return SLifeAlert.latestAlert
    }
    
    fileprivate static func setNew() {
        let alerts = DataAccess.sharedInstance.getObjects(.none) as [SLifeAlert]
        let latestAlerts = alerts.filter { obj in
            return obj.isNew?.boolValue ?? false
        }
        let sortedAlerts = latestAlerts.sorted(by: { $0.date ?? "" > $1.date ?? "" })
        var index = 0
        for obj in sortedAlerts {
            if index != 0 {
                obj.isNew = 0
            }
            index = index + 1
        }
        _ = DataAccess.sharedInstance.saveContextWithID()
        if sortedAlerts.count > 0 {
            latestAlert = sortedAlerts[0]
        }
    }
    
    static func convertNewAlertsOld() {
        let alerts = DataAccess.sharedInstance.getObjects(.none) as [SLifeAlert]
        for obj in alerts {
            obj.isNew = false
        }
        _ = DataAccess.sharedInstance.saveContextWithID()
    }
}

