//
//  IngredientRepository.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import CoreData

final class IngredientRepository {
    //MARK: - Properties
    private let coreDataStack: CoreDataStack
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Repository
    func saveIngredient(named name: String, completion: (_ success: Bool) -> Void) {
        let ingredient = Ingredient(context: coreDataStack.viewContext)
        ingredient.name = name
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            print("We were unable to save \(name)")
            completion(false)
        }
    }
    
    func getIngredients(completion: (_ success: Bool, _ ingredients: [Ingredient]) -> Void) {
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        guard let ingredients = try? coreDataStack.viewContext.fetch(request) else {
            completion(false, [])
            return
        }
        
        completion(true, ingredients)
    }
    
    func removeAllIngredient(completion: (_ success: Bool) -> Void) {
        getIngredients { success, ingredients in
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
