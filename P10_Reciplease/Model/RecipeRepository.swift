//
//  RecipeRepository.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import CoreData

final class RecipeRepository {
    //MARK: - Properties
    private let coreDataStack: CoreDataStack
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Repository
    func saveRecipe(title: String, ingredient: String, rate: String, imageUrl: String, duration: Double, completion: (_ success: Bool) -> Void) {
        let recipe = Recipe(context: coreDataStack.viewContext)
        recipe.title = title
        recipe.ingredient = ingredient
        recipe.rate = rate
        recipe.imageUrl = imageUrl
        recipe.duration = duration
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            print("We were unable to save recipe")
            completion(false)
        }
    }
    
    func getRecipes(completion: (_ success: Bool, _ recipes: [Recipe]) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        guard let recipes = try? coreDataStack.viewContext.fetch(request) else {
            completion(false, [])
            return
        }
        
        completion(true, recipes)
    }
    
    func removeAllRecipes(_ completion: (Bool) -> Void) {
        getRecipes { success, recipes in
            if success {
                for recipe in recipes {
                    coreDataStack.viewContext.delete(recipe)
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
