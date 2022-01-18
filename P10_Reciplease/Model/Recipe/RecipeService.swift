//
//  RecipeService.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import Alamofire

class RecipeService {
    //MARK: - Singleton
    static var shared = RecipeService()
    
    //MARK: - Properties
    static let baseUrl = "https://api.edamam.com/api/recipes/v2"
    private let appId = "490915d3"
    private let appKey = "6eb213ece561751aedcd1e4aa3a02dc8"
    private let type = "public"
    
    private let recipeRepository = FavoriteRecipeRepository()
    
    //MARK: - Alert Notification
    private func alertNotification(message: String) {
        let alertName = Notification.Name("alert")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    }
    
    //MARK: - Public
    func fetchRecipes(atUrl url: String, withIngredients ingredients: [FridgeIngredient], completion: @escaping (_ success: Bool, _ recipes: [RecipeModel], _ nextPageUrl: String?) -> Void) {
        if ingredients.isEmpty && url == RecipeService.baseUrl {
            alertNotification(message: "Add ingredients before searching for a recipe!")
            completion(false, [], nil)
            return
        }
        
        let ingredients = getIngredientsString(from: ingredients)
        let parameters: [String: String] = ["app_id": appId, "app_key": appKey, "type": type, "q": ingredients]
        
        AF.request(url, parameters: parameters).validate().responseDecodable(of: RecipeData.self) { response in
            guard let recipesData = response.value else {
                self.alertNotification(message: "Unable to fetch recipes data")
                completion(false, [], nil)
                return
            }
            
            self.createRecipeModels(from: recipesData) { recipes in
                if !recipes.isEmpty {
                    completion(true, recipes, recipesData.links.next.href)
                } else {
                    self.alertNotification(message: "No recipes found for these ingredients!")
                    completion(false, [], nil)
                }
            }
        }
    }
    
    //MARK: - Private
    private init() {}
    
    private func getIngredientsString(from ingredients: [FridgeIngredient]) -> String {
        var ingredientsString = ""
        
        for ingredient in ingredients {
            ingredientsString += "\(ingredient.name ?? "") "
        }
        
        return ingredientsString
    }
    
    private func getImage(from url: String, completion: @escaping (_ recipeImage: UIImage) -> Void) {
        AF.request(url).responseData { response in
            if response.error == nil {
                if let data = response.data {
                    completion(UIImage(data: data)!)
                }
            } else {
                completion(UIImage(named: "Food")!)
            }
        }
    }
    
    private func createRecipeModels(from data: RecipeData, completion: @escaping (_ recipes: [RecipeModel]) -> Void) {
        var recipes = [RecipeModel]()
        let myGroup = DispatchGroup()
        
        for recipe in data.hits {
            myGroup.enter()
            
            var ingredients = [RecipeIngredientModel]()
            for ingredient in recipe.recipe.ingredients {
                let newIngredient = RecipeIngredientModel(text: ingredient.text,
                                                          quantity: ingredient.quantity,
                                                          measure: ingredient.measure ?? "",
                                                          food: ingredient.food,
                                                          weight: ingredient.weight,
                                                          foodCategory: ingredient.foodCategory ?? "")
                ingredients.append(newIngredient)
            }
            
            let title = recipe.recipe.label
            let rate = "\(recipe.recipe.yield)"
            let duration = recipe.recipe.totalTime
            let recipeUrl = recipe.recipe.url
            let imageUrl = recipe.recipe.image
            
            self.getImage(from: imageUrl) { recipeImage in
                recipes.append(RecipeModel(title: title, ingredients: ingredients, rate: rate, image: recipeImage, duration: Double(duration), url: recipeUrl))
                myGroup.leave()
            }
        }
        
        // Execute completionHandler asyncronously when all request are finished
        myGroup.notify(queue: .main) {
            completion(recipes)
        }
    }
}
