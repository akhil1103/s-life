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
    
    static func processAndGetAlertResponse(response: AlertResponse) -> [SLifeAlert] {
        for obj in response {
            if let id = obj.id, let _ = DataAccess.sharedInstance.getObjectWithLocalId(id) as SLifeAlert? {
                print("\(id) existed")
                continue
            } else {
                let alertObj = DataAccess.sharedInstance.createObject() as SLifeAlert
                alertObj.id = obj.id
                alertObj.title = obj.title
                alertObj.desc = obj.desc
                alertObj.category = NSNumber(value: obj.category?.rawValue ?? 0)
                alertObj.date = obj.date
                alertObj.lat = NSNumber(value: obj.location?.lat ?? 0.0)
                alertObj.long = NSNumber(value: obj.location?.long ?? 0.0)
                print("\(String(describing: obj.id)) created")
            }
        }
        _ = DataAccess.sharedInstance.saveContextWithID()
        let alerts = DataAccess.sharedInstance.getObjects(.none) as [SLifeAlert]
        return alerts
    }
}

