//
//  RecipeIngredientRepository.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 15/01/2022.
//

import Foundation
import CoreData

final class RecipeIngredientRepository {
    //MARK: - Properties
    private let coreDataStackShared = CoreDataStack.sharedInstance

    private let viewContext: NSManagedObjectContext
    private let favoriteRecipeRepository: FavoriteRecipeRepository
    
    //MARK: - Init
    init(viewContext: NSManagedObjectContext = CoreDataStack.sharedInstance.viewContext, repository: FavoriteRecipeRepository = FavoriteRecipeRepository()) {
        self.viewContext = viewContext
        self.favoriteRecipeRepository = repository
    }
    
    //MARK: - Repository
    func saveRecipeIngredients(forRecipe recipe: RecipeModel, ingredientsModel: [RecipeIngredientModel], completion: (_ success: Bool) -> Void) {
        favoriteRecipeRepository.getFavoriteRecipe(named: recipe.title) { success, recipe in
            if success {
                for ingredientModel in ingredientsModel {
                    let ingredient = RecipeIngredient(context: viewContext)
                    ingredient.recipe = recipe
                    ingredient.text = ingredientModel.text
                    ingredient.quantity = ingredientModel.quantity
                    ingredient.measure = ingredientModel.measure
                    ingredient.weight = ingredientModel.weight
                    ingredient.food = ingredientModel.food
                    ingredient.foodCategory = ingredientModel.foodCategory
                    
                    if !coreDataStackShared.saveContext() { return }
                }
                completion(true)
            }
        }
    }
}

