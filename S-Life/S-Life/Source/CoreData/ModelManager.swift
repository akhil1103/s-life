//
//  ModelManager.swift
//  S-Life
//
//  Created by Akhil Mittal on 02/03/22.
//


import CoreData
import Foundation
import UIKit

public protocol CoreDataStackProvider {
    func getMainContext() -> NSManagedObjectContext
}

extension ModelManager: CoreDataStackProvider { }

public class ModelManager {
    
    public static let sharedInstance = ModelManager()
    
    fileprivate var container: NSPersistentContainer!
    
    func createContainer() {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        container = appDel.persistentContainer
    }
    
    public func getMainContext() -> NSManagedObjectContext {
        let context =  container.viewContext
        return context
    }
}

fileprivate extension ModelManager {
    @objc func applicationWillTerminateNotification(_ notification: Notification) {
        print("Trying to save main context, if any pending changes")
        container.viewContext.perform { [weak self] in
            guard let weakSelf = self else { return }
            if weakSelf.container.viewContext.hasChanges {
                weakSelf.container.viewContext.saveContext()
            }
        }
    }
}

fileprivate final class ManagedObjectContext: NSManagedObjectContext {
    override init(concurrencyType ct: NSManagedObjectContextConcurrencyType) {
        super.init(concurrencyType: ct)
        print("concurrencyType Init child managedObjectContext")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("coder Init child managedObjectContext")
    }
    
    deinit {
        print("Dealloc child managedObjectContext")
    }
}
