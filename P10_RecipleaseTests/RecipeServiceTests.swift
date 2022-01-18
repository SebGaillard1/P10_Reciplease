//
//  RecipeServiceTests.swift
//  P10_RecipleaseTests
//
//  Created by Sebastien Gaillard on 18/01/2022.
//

import XCTest
import Alamofire
@testable import P10_Reciplease

class RecipeServiceTests: XCTestCase {
    private var recipeService: RecipeService!
    private var fridgeIngredients: [FridgeIngredient]!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        recipeService = RecipeService(session: session)
        
        let ingredient = FridgeIngredient()
        ingredient.name = "Chicken"
        fridgeIngredients = [ingredient]
    }

    override func tearDown() {
        super.tearDown()
        
        recipeService = nil
        fridgeIngredients = []
    }
    
    func testFetchRecipesShouldPostFailedCompletionIfError() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            return (response, data, error)
        }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.fetchRecipes(atUrl: RecipeService.baseUrl, withIngredients: fridgeIngredients) { success, recipes, nextPageUrl in
            // Then
            XCTAssertFalse(success)
            XCTAssertTrue(recipes.isEmpty)
            XCTAssertNil(nextPageUrl)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testFetchRecipesShouldPostFailedCompletionIfIncorrectResponse() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.recipeData
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            return (response, data, error)
        }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.fetchRecipes(atUrl: RecipeService.baseUrl, withIngredients: fridgeIngredients) { success, recipes, nextPageUrl in
            // Then
            XCTAssertFalse(success)
            XCTAssertTrue(recipes.isEmpty)
            XCTAssertNil(nextPageUrl)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testFetchRecipesShouldPostFailedCompletionIfIncorrectData() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.incorrectData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.fetchRecipes(atUrl: RecipeService.baseUrl, withIngredients: fridgeIngredients) { success, recipes, nextPageUrl in
            // Then
            XCTAssertFalse(success)
            XCTAssertTrue(recipes.isEmpty)
            XCTAssertNil(nextPageUrl)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    
}
