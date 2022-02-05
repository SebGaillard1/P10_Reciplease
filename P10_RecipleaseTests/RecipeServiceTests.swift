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
    var coreDataStack: CoreDataTestStack!
    
    private var recipeService: RecipeService!
    private var fridgeIngredients: [FridgeIngredient]!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        recipeService = RecipeService(session: session)
        
        coreDataStack = CoreDataTestStack()
        let ingredient = FridgeIngredient(context: coreDataStack.viewContext)
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
    
    func testFetchRecipesShouldPostSuccessIfDataGoodResponseNoError() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.recipeData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.fetchRecipes(atUrl: RecipeService.baseUrl, withIngredients: fridgeIngredients) { success, recipes, nextPageUrl in
            // Then
            XCTAssertTrue(success)
            XCTAssertFalse(recipes.isEmpty)
            XCTAssertNotNil(nextPageUrl)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenNoIngredientWhenFetchingRecipesThenShouldPostFail() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.recipeData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.fetchRecipes(atUrl: RecipeService.baseUrl, withIngredients: []) { success, recipes, nextPageUrl in
            // Then
            XCTAssertFalse(success)
            XCTAssertTrue(recipes.isEmpty)
            XCTAssertNil(nextPageUrl)
            expectation.fulfill()        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenIngredientsWithNoRecipeWhenFetchingRecipesThenShouldPostFail() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.noRecipeData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.fetchRecipes(atUrl: RecipeService.baseUrl, withIngredients:fridgeIngredients) { success, recipes, nextPageUrl in
            // Then
            XCTAssertFalse(success)
            XCTAssertTrue(recipes.isEmpty)
            XCTAssertNil(nextPageUrl)
            expectation.fulfill()        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenIngredientsWithNoNameWhenFetchingRecipesThenShouldReplaceByEmptyString() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.noRecipeData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        // When
        fridgeIngredients.append(FridgeIngredient(context: coreDataStack.viewContext))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.fetchRecipes(atUrl: RecipeService.baseUrl, withIngredients:fridgeIngredients) { success, recipes, nextPageUrl in
            // Then
            XCTAssertFalse(success)
            XCTAssertTrue(recipes.isEmpty)
            XCTAssertNil(nextPageUrl)
            expectation.fulfill()        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenImageDataWithNoErrorAndGoodResponseWhenDownloadingImageThenShouldPostDownloadedImage() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.imageData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        let recipe = RecipeModel(title: "Exemple", ingredients: [RecipeIngredientModel](), rate: "1", image: UIImage(), imageUrl: "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg", duration: 12, url: "www.url.fr")
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipeService.getImage(forRecipe: recipe) { recipeWithImage in
            // Then
            XCTAssertNotNil(recipeWithImage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenAnErrorWhenDownloadingImageThenShouldPostDefaultImage() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.incorrectData
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = Alamofire.AFError.invalidURL(url: "badurl")
            return (response, data, error)
        }
        
        let recipe = RecipeModel(title: "Exemple", ingredients: [RecipeIngredientModel](), rate: "1", image: UIImage(), imageUrl: "badurl", duration: 12, url: "www.url.fr")
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipeService.getImage(forRecipe: recipe) { recipeWithImage in
            // Then
            XCTAssertNotNil(recipeWithImage)
            XCTAssertEqual(recipeWithImage.image.pngData(), UIImage(named: "Food")?.pngData())
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
}
