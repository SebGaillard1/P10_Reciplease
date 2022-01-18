////
////  CoreDataTests.swift
////  P10_RecipleaseTests
////
////  Created by Sebastien Gaillard on 18/01/2022.
////
//
//import XCTest
//import CoreData
//@testable import P10_Reciplease
//
//class CoreDataTests: XCTestCase {
//    var testCoreDataStack: TestCoreDataStack!
//
//    var recipeIngredientRepository: RecipeIngredientRepository!
//    var favoriteRecipeRepository: FavoriteRecipeRepository!
//
//    private let recipe = RecipeModel(title: "Chicken Massala", ingredients: [], rate: "8", image: UIImage(named: "Food")!, duration: 8, url: "fer")
//    private let ingredients = [RecipeIngredientModel(text: "Tomato", quantity: 3.0, measure: "g", food: "tomato", weight: 0.5, foodCategory: "Vegetables")]
//
//
//    override func setUp() {
//        super.setUp()
//        testCoreDataStack = TestCoreDataStack()
//        recipeIngredientRepository = RecipeIngredientRepository(coreDataStack: testCoreDataStack)
//        favoriteRecipeRepository = FavoriteRecipeRepository(coreDataStack: testCoreDataStack)
//    }
//
//    override class func tearDown() {
//        super.tearDown()
////        testCoreDataStack = nil
////        sut = nil
//    }
//
//    //MARK: - RecipeIngredient Tests
//    func testSaveIngredientAssociatedToARecipe() {
//        // When
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
//            recipeIngredientRepository.saveRecipeIngredients(forRecipe: recipe, ingredientsModel: ingredients) { success in
//                // Then
//                XCTAssertTrue(success)
//                XCTAssertTrue(ingredients[0].text == "Tomato")
//                expectation.fulfill()
//            }
//        }
//    }
//
//    //MARK: - FridgeIngredient Tests
//    func testSaveFridgeIngredient() {
//
//    }
//
//}
