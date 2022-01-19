//
//  CoreDataTests.swift
//  P10_RecipleaseTests
//
//  Created by Sebastien Gaillard on 18/01/2022.
//

import XCTest
import CoreData
@testable import P10_Reciplease

class FavoriteRecipeRepositoryTests: XCTestCase {
    var coreDataStack: CoreDataTestStack!
    var recipeIngredientRepository: RecipeIngredientRepository!
    var favoriteRecipeRepository: FavoriteRecipeRepository!
    
    var ingredient: RecipeIngredientModel!
    var recipe: RecipeModel!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        favoriteRecipeRepository = FavoriteRecipeRepository(viewContext: coreDataStack.viewContext)
        recipeIngredientRepository = RecipeIngredientRepository(viewContext: coreDataStack.viewContext, repository: favoriteRecipeRepository)
        
        ingredient = RecipeIngredientModel(text: "Tomato", quantity: 3.0, measure: "g", food: "tomato", weight: 0.5, foodCategory: "Vegetables")
        recipe = RecipeModel(title: "Chicken Massala", ingredients: [ingredient], rate: "8", image: UIImage(named: "Food")!, duration: 8, url: "fer")
    }

    //MARK: - RecipeIngredient Tests
    func testSaveIngredientAssociatedToARecipe() {
        // When
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            XCTAssertTrue(success)
        }
        recipeIngredientRepository.saveRecipeIngredients(forRecipe: recipe, ingredientsModel: [ingredient]) { success in
            XCTAssertTrue(success)
        }
        favoriteRecipeRepository.getFavoriteRecipe(named: recipe.title) { success, recipe in
            XCTAssertTrue(success)
            favoriteRecipeRepository.getIngredientModels(forRecipe: recipe!) { success, ingredients in
                XCTAssertTrue(success)
                XCTAssertEqual(ingredients[0].text, "Tomato")
            }
        }
    }
}
