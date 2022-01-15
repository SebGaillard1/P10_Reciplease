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
    private let coreDataStack: CoreDataStack
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Repository
    func saveFridgeIngredient(named name: String, completion: (_ success: Bool) -> Void) {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            completion(false)
            return
        }
        
        let ingredient = FridgeIngredient(context: coreDataStack.viewContext)
        ingredient.name = name
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            print("We were unable to save \(name)")
            completion(false)
        }
    }
    
    func getFridgeIngredients(completion: (_ success: Bool, _ ingredients: [FridgeIngredient]) -> Void) {
        let request: NSFetchRequest<FridgeIngredient> = FridgeIngredient.fetchRequest()
        
        guard let ingredients = try? coreDataStack.viewContext.fetch(request) else {
            completion(false, [])
            return
        }
        
        completion(true, ingredients)
    }
    
    func removeAllIngredient(completion: (_ success: Bool) -> Void) {
        getFridgeIngredients { success, ingredients in
            if success {
                for ingredient in ingredients {
                    coreDataStack.viewContext.delete(ingredient)
                }
            } else {
                completion(false)
            }
        }
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            completion(false)
            print("We were unable to remove the ingredients")
        }
    }
}
