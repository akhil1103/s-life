//
//  DataAccess.swift
//  S-Life
//
//  Created by balabalaji on 03/10/21.
//

import Foundation
import CoreData

public class DataAccess {
    public static let sharedInstance = DataAccess()
    fileprivate init() {} //Singleton
    
    var modelManager: CoreDataStackProvider = ModelManager.sharedInstance
    
    public func saveContextWithID() -> Bool {
        let thisContext = getContext()
        
        if thisContext.hasChanges {
            do {
                try thisContext.save()
                return true
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                return false
            }
        }
        
        return true
    }
    
    
    fileprivate func getContext() -> NSManagedObjectContext {
        return modelManager.getMainContext()
    }
    
    public func getObjects<T>(
        _ options: FetchOptions?
        ) -> [T] where T: BaseModelObject, T: NSManagedObject {
        
        //prepare fetch query
        let fetch = NSFetchRequest<T>(entityName: T.entityName())
        fetch.includesSubentities = false
        
        if let options = options {
            if let limit = options.limit {
                fetch.fetchLimit = limit
            }
            if let sort = options.sort {
                var sortDescriptors = [NSSortDescriptor]()
                for sortOption in sort {
                    var sortDescriptor: NSSortDescriptor
                    if let selector = sortOption.selector {
                        sortDescriptor = NSSortDescriptor(key: sortOption.key, ascending: sortOption.ascending, selector: selector)
                    } else if let comparator = sortOption.comparator {
                        sortDescriptor = NSSortDescriptor(key: sortOption.key, ascending: sortOption.ascending, comparator: comparator)
                    } else {
                        sortDescriptor = NSSortDescriptor(key: sortOption.key, ascending: sortOption.ascending)
                    }
                    
                    sortDescriptors.append(sortDescriptor)
                }
                fetch.sortDescriptors = sortDescriptors
            }
            if let query = options.query {
                let predicate = NSPredicate(format: query)
                fetch.predicate = predicate
            }
        }
        
        //execute query
        let thisContext = getContext()
        do {
            let result = try thisContext.fetch(fetch)
            return result
        } catch {
            return []
        }
    }
    
    public func createObject<T>() -> T where T: BaseModelObject, T: NSManagedObject {
        let thisContext = getContext()
        let modelClassName = T.entityName()

        let entity = NSEntityDescription.insertNewObject(forEntityName: modelClassName, into: thisContext) as! T
        
        return entity
    }
    
    public func getObjectWithLocalId<T>(
        _ withId: String
        ) -> T? where T: BaseModelObject, T: NSManagedObject {
        
        let predicate = NSPredicate(format: "id == %@", withId)
        return fetchObjectMatchingPredicate(predicate)
    }
    
    public func fetchObjectMatchingPredicate<T>(
        _ predicate: NSPredicate,
        sortDescriptors:[NSSortDescriptor]? = nil
        ) -> T?  where T: BaseModelObject, T: NSManagedObject {
        
        let context = getContext()
        let fetch = NSFetchRequest<T>(entityName: T.entityName())
        fetch.includesSubentities = false
        fetch.predicate = predicate
        fetch.sortDescriptors = sortDescriptors
        fetch.fetchLimit = 1
        
        return (try? context.fetch(fetch))?.first
    }
    
}

public struct SortOption {
    public var key: String!
    public var ascending = true
    public var selector: Selector? = nil
    public var comparator: Comparator? = nil
    
    public init(key: String) {
        self.key = key
    }
}

public struct FetchOptions {
    public var sort: [SortOption]? = nil
    public var query: String? = nil
    public var limit: Int? = nil
    
    public init() {
        
    }
    
    public init(query: String, limit: Int = 1) {
        self.query = query
        self.limit = limit
    }
    
    public init(query: String, args: String..., limit: Int = 1) {
        //convert args to array, args value will not work as arguments for String(format:
        var temp = [CVarArg]()
        for arg in args {
            temp.append(arg)
        }
        self.query = String(format: query.replacingOccurrences(of: "%S", with: "\"%@\""), arguments: temp)
        self.limit = limit
    }
}


