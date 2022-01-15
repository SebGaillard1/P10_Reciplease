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
    private let coreDataStack: CoreDataStack
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Repository
    func saveRecipeAsFavorite(recipe recipeModel: RecipeModel, completion: (_ success: Bool) -> Void) {
        guard let data = recipeModel.image.pngData() else {
            completion(false)
            return
        }
        
        let recipe = Recipe(context: coreDataStack.viewContext)
        recipe.title = recipeModel.title
        recipe.ingredient = recipeModel.detailIngredientsList
        recipe.rate = recipeModel.rate
        recipe.imageData = data
        recipe.duration = recipeModel.duration
        recipe.url = recipeModel.url
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            print("We were unable to save recipe")
            completion(false)
        }
    }
    
    func getFavoriteRecipe(named name: String, completion: (_ success: Bool, _ recipe: Recipe?) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", name)
        
        guard let recipes = try? coreDataStack.viewContext.fetch(request) else {
            completion(false, nil)
            return
        }
        
        completion(true, recipes[0])
    }
    
    private func getAllFavoriteRecipesWithImageData(completion: (_ success: Bool, _ recipes: [Recipe]) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        guard let recipes = try? coreDataStack.viewContext.fetch(request) else {
            completion(false, [])
            return
        }
        
        completion(true, recipes)
    }
    
    func getFavoriteRecipiesWithUIImage(completion: (_ success: Bool, _ recipies: [RecipeModel]) -> Void) {
        getAllFavoriteRecipesWithImageData { success, recipes in
            if success {
                var recipesWithUIImage = [RecipeModel]()

                for recipe in recipes {
                    getIngredients(forRecipe: recipe) { success, ingredients in
                        if success {
                            recipesWithUIImage.append(RecipeModel(title: recipe.title!,
                                                                  ingredients: ingredients,
                                                                  rate: recipe.rate!,
                                                                  image: (UIImage(data: recipe.imageData!) ?? UIImage(named: "Food"))!,
                                                                  duration: recipe.duration,
                                                                  url: recipe.url!))
                        } else {
                            completion(false, [])
                        }
                    }
                }
                completion(true, recipesWithUIImage)
            }
            completion(false, [])
        }
    }
    
    func getIngredients(forRecipe recipe: Recipe, completion: (_ success: Bool, _ ingredients: [RecipeIngredientModel]) -> Void) {
        let request: NSFetchRequest<RecipeIngredient> = RecipeIngredient.fetchRequest()
        request.predicate = NSPredicate(format: "recipe.title == %@", recipe.title!)
        
        guard let ingredients = try? coreDataStack.viewContext.fetch(request) else {
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
        getAllFavoriteRecipesWithImageData { success, recipes in
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
