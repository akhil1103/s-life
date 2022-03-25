//
//  NSManagedObject+Name.swift
//  S-Life
//
//  Created by Akhil Mittal on 03/03/22.
//

import CoreData
import Foundation

extension NSManagedObject {
    public class func entityName() -> String {
        return String(describing: self)
    }
}
