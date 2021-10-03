//
//  NSManagedObject+Name.swift
//  S-Life
//
//  Created by balabalaji on 03/10/21.
//

import CoreData
import Foundation

extension NSManagedObject {
    public class func entityName() -> String {
        return String(describing: self)
    }
}
