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
    private let coreDataStack: CoreDataStack
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Repository
    func saveRecipeIngredient(forRecipe recipe: Recipe, text: String, quantity: Double, measure: String, weight: Double, food: String, foodCategory: String, completion: (_ success: Bool) -> Void) {
        let ingredient = RecipeIngredient(context: coreDataStack.viewContext)
        ingredient.recipe = recipe
        ingredient.text = text
        ingredient.quantity = quantity
        ingredient.measure = measure
        ingredient.weight = weight
        ingredient.food = food
        ingredient.foodCategory = foodCategory
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            print("We were unable to save \(ingredient.text ?? "an ingredient")")
            completion(false)
        }
    }

}

