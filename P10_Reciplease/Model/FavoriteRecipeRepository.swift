//
//  RecipeRepository.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import CoreData

final class FavoriteRecipeRepository {
    //MARK: - Properties
    private let coreDataStack: CoreDataStack
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Repository
    func saveRecipeAsFavorite(title: String, ingredient: String, rate: String, imageData: Data, duration: Double, completion: (_ success: Bool) -> Void) {
        let recipe = Recipe(context: coreDataStack.viewContext)
        recipe.title = title
        recipe.ingredient = ingredient
        recipe.rate = rate
        recipe.imageData = imageData
        recipe.duration = duration
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            print("We were unable to save recipe")
            completion(false)
        }
    }
    
    func getFavoriteRecipes(completion: (_ success: Bool, _ recipes: [Recipe]) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        guard let recipes = try? coreDataStack.viewContext.fetch(request) else {
            completion(false, [])
            return
        }
        
        completion(true, recipes)
    }
    
//    func removeAllFavoriteRecipes(_ completion: (Bool) -> Void) {
//        getFavoriteRecipes { success, recipes in
//            if success {
//                for recipe in recipes {
//                    coreDataStack.viewContext.delete(recipe)
//                }
//            } else {
//                completion(false)
//            }
//        }
//        
//        do {
//            try coreDataStack.viewContext.save()
//            completion(true)
//        } catch {
//            completion(false)
//            print("We were unable to remove the ingredients")
//        }
//    }
    
    func removeFromFavorite(recipe: RecipeModel, completion: (_ success: Bool) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", recipe.title)
        
        guard let recipes = try? coreDataStack.viewContext.fetch(request) else {
            completion(false)
            return
        }
        
        for recipe in recipes {
            coreDataStack.viewContext.delete(recipe)
        }
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            completion(false)
            print("We were unable to remove recipe from favorite")
        }
        
    }
    
    func isRecipeAlreadyFavorite(recipe: RecipeModel,completion: (_ favorite: Bool) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", recipe.title)
        
        guard let recipes = try? coreDataStack.viewContext.fetch(request) else {
            completion(false)
            return
        }
        if !recipes.isEmpty {
            completion(true)
        } else {
            completion(false)
        }
    }
}
