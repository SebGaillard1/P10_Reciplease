//
//  CoreDataStack.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import CoreData

open class CoreDataStack {
    //MARK: - Properties
    private let persistantContainerName = "P10_Reciplease"
    
    //MARK: - Singleton
    static let sharedInstance = CoreDataStack()

    //MARK: - Public
    let viewContext: NSManagedObjectContext
    let persistantContainer: NSPersistentContainer

    //MARK: - Private
    private init() {
        persistantContainer = NSPersistentContainer(name: persistantContainerName)
        let description = persistantContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        
        persistantContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        viewContext = persistantContainer.viewContext
    }
}
