//
//  FridgeIngredientRepositoryTests.swift
//  P10_RecipleaseTests
//
//  Created by Sebastien Gaillard on 18/01/2022.
//

import XCTest
import CoreData
@testable import P10_Reciplease

class FridgeIngredientRepositoryTest: XCTestCase {
    var coreDataStack: CoreDataTestStack!
    var fridgeIngredientRepository: FridgeIngredientRepository!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        fridgeIngredientRepository = FridgeIngredientRepository(viewContext: coreDataStack.viewContext)

    }
    
    //MARK: - RecipeIngredient Tests
    func testGivenGoodIngredientsWhenSavingFridgeIngredientShouldSuccess() {
        // Given
        let ingredients = "Chicken"
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fridgeIngredientRepository.saveFridgeIngredient(named: ingredients) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
    }
    
    func testGivenFridgeIngredientsSavedWhenGettingFridgeIngredientShouldSuccess() {
        // Given
        let ingredients = "Chicken"
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fridgeIngredientRepository.saveFridgeIngredient(named: ingredients) { success in
            // Then
            fridgeIngredientRepository.getFridgeIngredients { success, ingredients in
                XCTAssertTrue(success)
                XCTAssertEqual(ingredients.count, 1)
                XCTAssertEqual(ingredients[0].name, "Chicken")
                expectation.fulfill()
            }
        }
    }

    func testGivenAnIngredientWithEmptyNameWhenSavingItThenShouldPostFail() {
        // Given
        let ingredient = ""
        // When
        fridgeIngredientRepository.saveFridgeIngredient(named: ingredient) { success in
            // Then
            XCTAssertFalse(success)
        }
    }
    
    func testRemoveFridgeIngredient() {
        // Given
        let ingredients = "Chicken"
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fridgeIngredientRepository.saveFridgeIngredient(named: ingredients) { success in
            // Then
            fridgeIngredientRepository.getFridgeIngredients { success, ingredients in
                fridgeIngredientRepository.removeIngredient(ingredient: ingredients[0]) { success in
                    XCTAssertTrue(success)
                    fridgeIngredientRepository.getFridgeIngredients { success, ingredients in
                        XCTAssertTrue(success)
                        XCTAssertEqual(ingredients.count, 0)
                        expectation.fulfill()
                    }
                }
            }
        }
    }
    
    func testRemoveAllFridgeIngredients() {
        // Given
        let ingredients = "Chicken"
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fridgeIngredientRepository.saveFridgeIngredient(named: ingredients) { success in
            // Then
            fridgeIngredientRepository.getFridgeIngredients { success, ingredients in
                fridgeIngredientRepository.removeAllIngredients { success in
                    XCTAssertTrue(success)
                    fridgeIngredientRepository.getFridgeIngredients { success, ingredients in
                        XCTAssertTrue(success)
                        XCTAssertEqual(ingredients.count, 0)
                        expectation.fulfill()
                    }
                }
            }
        }
    }
}
