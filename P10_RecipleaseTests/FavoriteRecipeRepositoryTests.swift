//
//  FavoriteRecipeRepositoryTests.swift
//  P10_RecipleaseTests
//
//  Created by Sebastien Gaillard on 20/01/2022.
//

import XCTest
@testable import P10_Reciplease


class FavoriteRecipeRepositoryTests: XCTestCase {
    var coreDataStack: CoreDataTestStack!
    var favoriteRecipeRepository: FavoriteRecipeRepository!
    
    var ingredient: RecipeIngredientModel!
    var recipe: RecipeModel!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        favoriteRecipeRepository = FavoriteRecipeRepository(viewContext: coreDataStack.viewContext)
        
        ingredient = RecipeIngredientModel(text: "Tomato", quantity: 3.0, measure: "g", food: "tomato", weight: 0.5, foodCategory: "Vegetables")
        recipe = RecipeModel(title: "Chicken Massala", ingredients: [ingredient], rate: "8", image: UIImage(named: "Food")!, imageUrl: "", duration: 8, url: "url")
    }
    
    func testGivenARecipeWhenSavingItToFavoriteThenShouldPostSuccess() {
        // When
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            // Then
            XCTAssertTrue(success)
        }
    }
    
    func testGivenAFavoriteRecipeWhenGettingItThenShouldGet1FavoriteRecipe() {
        // Given
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            XCTAssertTrue(success)
        }
        // When
        favoriteRecipeRepository.getFavoriteRecipe(named: "Chicken Massala") { success, recipe in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(recipe?.title, "Chicken Massala")
        }
    }
    
    func testGivenTwoFavoriteRecipesWhenGettingAllFavoriteRecipesThenShouldHave2Favorites() {
        // Given
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            XCTAssertTrue(success)
        }
        let recipe2 = RecipeModel(title: "Tartiflette", ingredients: [ingredient], rate: "5", image: UIImage(named: "Food")!, imageUrl: "", duration: 5, url: "url")
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe2) { success in
            XCTAssertTrue(success)
        }
        // When
        favoriteRecipeRepository.getAllFavoriteRecipesModel { success, recipes in
            // Then
            XCTAssertTrue(success)
            XCTAssertTrue(recipes.count == 2)
        }
    }
    
    func testGivenAFavoriteRecipeWhenRemovingItThenShouldNotHaveFavoriteRecipe() {
        // Given
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            XCTAssertTrue(success)
        }
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            XCTAssertTrue(success)
        }
        // When
        favoriteRecipeRepository.removeFromFavorite(recipe: recipe) { success in
            XCTAssertTrue(success)
        }
        favoriteRecipeRepository.getAllFavoriteRecipesModel { success, recipes in
            // Then
            XCTAssertTrue(success)
            XCTAssertTrue(recipes.isEmpty)
        }
    }
    
    func testGivenTwoRecipesWhenRemovingAllThenShouldNotHaveFavoriteRecipe() {
        // Given
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            XCTAssertTrue(success)
        }
        let recipe2 = RecipeModel(title: "Tartiflette", ingredients: [ingredient], rate: "5", image: UIImage(named: "Food")!, imageUrl: "", duration: 5, url: "url")
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe2) { success in
            XCTAssertTrue(success)
        }
        // When
        favoriteRecipeRepository.removeAllFavoriteRecipes { success in
            XCTAssertTrue(success)
        }
        // Then
        favoriteRecipeRepository.getAllFavoriteRecipesModel { success, recipes in
            XCTAssertTrue(success)
            XCTAssertTrue(recipes.isEmpty)
        }
    }
    
    func testGivenRecipeWithBadImageWhenSavingItThenShouldFailed() {
        // Given
        let recipeWithBadImage = RecipeModel(title: "Recipe", ingredients: [ingredient], rate: "9", image: UIImage(), imageUrl: "", duration: 3, url: "url")
        // When
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipeWithBadImage) { success in
            // Then
            XCTAssertFalse(success)
        }
    }
    
    func testGivenAFavoriteRecipeWhenCheckingIfItsFavoriteThenShouldPostTrue() {
        // Given
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            XCTAssertTrue(success)
        }
        // When
        favoriteRecipeRepository.isRecipeFavorite(recipe: recipe) { favorite in
            // Then
            XCTAssertTrue(favorite)
        }
    }
    
    func testGivenNoFavoriteRecipeWhenCheckingIfItsFavoriteThenShouldPostFalse() {
        // When
        favoriteRecipeRepository.isRecipeFavorite(recipe: recipe) { favorite in
            // Then
            XCTAssertFalse(favorite)
        }
    }

}
