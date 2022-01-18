//
//  TestCoreDataStack.swift
//  P10_RecipleaseTests
//
//  Created by Sebastien Gaillard on 18/01/2022.
//

import Foundation
import CoreData
@testable import P10_Reciplease

struct CoreDataTestStack {
    private let persistantContainerName = "P10_Reciplease"

    let persistentContainer: NSPersistentContainer
    let viewContext: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: persistantContainerName)
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
}
