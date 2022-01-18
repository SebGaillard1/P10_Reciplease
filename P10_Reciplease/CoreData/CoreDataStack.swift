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
    let persistantContainer: NSPersistentContainer
    
    //MARK: - Singleton
    static let sharedInstance = CoreDataStack()

    //MARK: - Public
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistantContainer.viewContext
    }
    
    //MARK: - Private
    private init() {
        persistantContainer = NSPersistentContainer(name: persistantContainerName)
        
        let container = NSPersistentContainer(name: persistantContainerName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for \(storeDescription.description)")
            }
        }
    }
}
