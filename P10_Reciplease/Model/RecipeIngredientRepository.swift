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
    private var coreDataStack: CoreDataStack = CoreDataStack.sharedInstance
    private let favoriteRecipeRepository = FavoriteRecipeRepository(coreDataStack: CoreDataStack.sharedInstance)
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Alert Notification
    private func alertNotification(message: String) {
        let alertName = Notification.Name("alert")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    }
    
    //MARK: - Repository
    func saveRecipeIngredients(forRecipe recipe: RecipeModel, ingredientsModel: [RecipeIngredientModel], completion: (_ success: Bool) -> Void) {
        favoriteRecipeRepository.getFavoriteRecipe(named: recipe.title) { success, recipe in
            if success {
                for ingredientModel in ingredientsModel {
                    let ingredient = RecipeIngredient(context: coreDataStack.viewContext)
                    ingredient.recipe = recipe
                    ingredient.text = ingredientModel.text
                    ingredient.quantity = ingredientModel.quantity
                    ingredient.measure = ingredientModel.measure
                    ingredient.weight = ingredientModel.weight
                    ingredient.food = ingredientModel.food
                    ingredient.foodCategory = ingredientModel.foodCategory
                    
                    do {
                        try coreDataStack.viewContext.save()
                    } catch {
                        self.alertNotification(message: "Unable to save \(ingredient.text ?? "an ingredient")")
                        completion(false)
                        return
                    }
                }
                completion(true)
            }
        }
    }
}

