//
//  IngredientRepository.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import CoreData

final class FridgeIngredientRepository {
    //MARK: - Properties
    private let coreDataStackShared = CoreDataStack.sharedInstance
    private let viewContext: NSManagedObjectContext
    
    //MARK: - Init
    init(viewContext: NSManagedObjectContext = CoreDataStack.sharedInstance.viewContext) {
        self.viewContext = viewContext
    }
    
    //MARK: - Repository
    func saveFridgeIngredient(named name: String, completion: (_ success: Bool) -> Void) {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            completion(false)
            return
        }
        
        let ingredient = FridgeIngredient(context: viewContext)
        ingredient.name = name
        
        if coreDataStackShared.saveContext() { completion(true) }
    }
    
    func getFridgeIngredients(completion: (_ success: Bool, _ ingredients: [FridgeIngredient]) -> Void) {
        let request: NSFetchRequest<FridgeIngredient> = FridgeIngredient.fetchRequest()
        
        if let ingredients = try? viewContext.fetch(request) {
            completion(true, ingredients)
        }
    }
    
    func removeAllIngredients(completion: (_ success: Bool) -> Void) {
        getFridgeIngredients { success, ingredients in
            if success {
                for ingredient in ingredients {
                    viewContext.delete(ingredient)
                }
            }
        }
        
        if coreDataStackShared.saveContext() { completion(true) }
    }
    
    func removeIngredient(ingredient: FridgeIngredient, completion: (_ success: Bool) -> Void) {
        viewContext.delete(ingredient)
        if coreDataStackShared.saveContext() { completion(true) }
    }
}
