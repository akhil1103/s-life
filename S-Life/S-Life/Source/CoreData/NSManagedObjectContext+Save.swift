//
//  NSManagedObjectContext+Save.swift
//  S-Life
//
//  Created by Akhil Mittal on 02/03/22.
//

import Foundation
import CoreData

internal enum SaveResult {
    case success
    case failure(Error)
}
internal typealias CoreDataStackSaveCompletion = (SaveResult) -> Void

extension NSManagedObjectContext {

    internal func saveContext(_ completion: CoreDataStackSaveCompletion? = nil) {
        func saveFlow() {
            do {
                try sharedSaveFlow()
                completion?(.success)
            } catch let saveError {
                completion?(.failure(saveError))
            }
        }
        
        switch concurrencyType {
        case .confinementConcurrencyType:
            saveFlow()
        case .privateQueueConcurrencyType,
             .mainQueueConcurrencyType:
            perform(saveFlow)
        @unknown default:
            fatalError()
        }
    }
    
    private func sharedSaveFlow() throws {
        guard hasChanges else {
            return
        }
        
        try save()
    }
}

