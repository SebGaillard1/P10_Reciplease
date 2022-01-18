//
//  RecipeRepository.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import CoreData
import UIKit

final class FavoriteRecipeRepository {
    //MARK: - Properties
    let viewContext: NSManagedObjectContext
    
    //MARK: - Init
    init(viewContext: NSManagedObjectContext = CoreDataStack.sharedInstance.viewContext) {
        self.viewContext = viewContext
    }
    
    //MARK: - Alert Notification
    private func alertNotification(message: String) {
        let alertName = Notification.Name("alert")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    }
    
    //MARK: - Repository
    func saveRecipeAsFavorite(recipe recipeModel: RecipeModel, completion: (_ success: Bool) -> Void) {
        guard let imageData = recipeModel.image.pngData() else {
            self.alertNotification(message: "Error while saving the recipe image!")
            completion(false)
            return
        }
        
        let recipe = Recipe(context: viewContext)
        recipe.title = recipeModel.title
        recipe.ingredient = recipeModel.detailIngredientsList
        recipe.rate = recipeModel.rate
        recipe.imageData = imageData
        recipe.duration = recipeModel.duration
        recipe.url = recipeModel.url
        
        saveContext() ? completion(true) : completion(false)
    }
    
    func getFavoriteRecipe(named name: String, completion: (_ success: Bool, _ recipe: Recipe?) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", name)
        
        guard let recipes = try? viewContext.fetch(request) else {
            self.alertNotification(message: "Error while retrieving the favorite recipe!")
            completion(false, nil)
            return
        }
        
        completion(true, recipes[0])
    }
    
    func getAllFavoriteRecipesModel(completion: (_ success: Bool, _ recipes: [RecipeModel]) -> Void) {
        getAllFavoriteRecipes { success, recipes in
            guard success else { completion(false, []); return }
            
            var recipesWithUIImage = [RecipeModel]()
            for recipe in recipes {
                getIngredientModels(forRecipe: recipe) { success, ingredients in
                    guard success else { completion(false, []); return }
                    
                    recipesWithUIImage.append(RecipeModel(title: recipe.title!,
                                                          ingredients: ingredients,
                                                          rate: recipe.rate!,
                                                          image: (UIImage(data: recipe.imageData!) ?? UIImage(named: "Food"))!,
                                                          duration: recipe.duration,
                                                          url: recipe.url!))
                }
            }
            
            completion(true, recipesWithUIImage)
        }
    }
    
    private func getAllFavoriteRecipes(completion: (_ success: Bool, _ recipes: [Recipe]) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        guard let recipes = try? viewContext.fetch(request) else {
            self.alertNotification(message: "Error while retrieving your favorites recipes!")
            completion(false, [])
            return
        }
        
        completion(true, recipes)
    }
    
    func getIngredientModels(forRecipe recipe: Recipe, completion: (_ success: Bool, _ ingredients: [RecipeIngredientModel]) -> Void) {
        let request: NSFetchRequest<RecipeIngredient> = RecipeIngredient.fetchRequest()
        request.predicate = NSPredicate(format: "recipe.title == %@", recipe.title!)
        
        guard let ingredients = try? viewContext.fetch(request) else {
            self.alertNotification(message: "Error while retrieving the ingredients!")
            completion(false, [])
            return
        }
        
        var allIngredients = [RecipeIngredientModel]()
        for ingredient in ingredients {
            allIngredients.append(RecipeIngredientModel(text: ingredient.text!,
                                                        quantity: ingredient.quantity,
                                                        measure: ingredient.measure!,
                                                        food: ingredient.food!,
                                                        weight: ingredient.weight,
                                                        foodCategory: ingredient.foodCategory!))
        }
        
        completion(true, allIngredients)
    }
    
    func removeAllFavoriteRecipes(_ completion: (Bool) -> Void) {
        getAllFavoriteRecipes { success, recipes in
            if success {
                for recipe in recipes {
                    viewContext.delete(recipe)
                }
            } else {
                self.alertNotification(message: "Error while removing your favorites recipes!")
                completion(false)
            }
        }
        
        saveContext() ? completion(true) : completion(false)
    }
    
    func removeFromFavorite(recipe: RecipeModel, completion: (_ success: Bool) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", recipe.title)
        
        guard let recipes = try? viewContext.fetch(request) else {
            self.alertNotification(message: "Error while removing the recipe from favorite!")
            completion(false)
            return
        }
        
        for recipe in recipes {
            viewContext.delete(recipe)
        }
        
        saveContext() ? completion(true) : completion(false)
    }
    
    func isRecipeFavorite(recipe: RecipeModel, completion: (_ favorite: Bool) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", recipe.title)
        
        guard let recipes = try? viewContext.fetch(request) else {
            self.alertNotification(message: "Error while retrieving favorites recipes")
            completion(false)
            return
        }
        
        recipes.isEmpty ? completion(false) : completion(true)
    }
    
    private func saveContext() -> Bool {
        do {
            try viewContext.save()
            return true
        } catch {
            self.alertNotification(message: "Error while saving context!")
            return false
        }
    }
}
