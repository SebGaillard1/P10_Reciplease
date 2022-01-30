//
//  RecipeService.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import Alamofire
import UIKit

class RecipeService {
    //MARK: - Singleton
    static var shared = RecipeService()
    
    //MARK: - Properties
    static let baseUrl = "https://api.edamam.com/api/recipes/v2"
    private let appId = "490915d3"
    private let appKey = "6eb213ece561751aedcd1e4aa3a02dc8"
    private let type = "public"
    
    private let recipeRepository = FavoriteRecipeRepository()
    
    private var session = Session(configuration: .default)
    
    init(session: Session) {
        self.session = session
    }
    
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
        
        session.request(url, parameters: parameters).validate().responseDecodable(of: RecipeData.self) { response in
            guard let recipesData = response.value else {
                self.alertNotification(message: "Unable to fetch recipes data")
                completion(false, [], nil)
                return
            }
            
            let recipes = self.createRecipeModels(from: recipesData)
            
            if !recipes.isEmpty {
                completion(true, recipes, recipesData.links.next.href)
            } else {
                self.alertNotification(message: "No recipes found for these ingredients!")
                completion(false, [], nil)
            }
        }
    }
    
    func getImage(forRecipe recipe: RecipeModel, completion: @escaping (_ recipe: RecipeModel) -> Void) {
        getImage(from: recipe.imageUrl) { recipeImage in
            let recipeModel = RecipeModel(title: recipe.title,
                                          ingredients: recipe.ingredients,
                                          rate: recipe.rate,
                                          image: recipeImage,
                                          imageUrl: recipe.imageUrl,
                                          duration: recipe.duration,
                                          url: recipe.url)
            completion(recipeModel)
        }
    }

    //MARK: - Private
    private init() {}
    
    private func getImage(from url: String, completion: @escaping (_ recipeImage: UIImage) -> Void) {
        AF.request(url).responseData { response in
            if response.error == nil {
                if let data = response.data {
                    completion(UIImage(data: data) ?? UIImage(named: "Food")!)
                }
            } else {
                completion(UIImage(named: "Food")!)
            }
        }
    }
    
    private func getIngredientsString(from ingredients: [FridgeIngredient]) -> String {
        var ingredientsString = ""
        
        for ingredient in ingredients {
            ingredientsString += "\(ingredient.name ?? "") "
        }
        
        return ingredientsString
    }
    
    private func createRecipeModels(from data: RecipeData) -> [RecipeModel] {
        var recipes = [RecipeModel]()
        
        for recipe in data.hits {
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
            let placeholderImage = UIImage(named: "1")!
            
            recipes.append(RecipeModel(title: title, ingredients: ingredients, rate: rate, image: placeholderImage, imageUrl: imageUrl ,duration: Double(duration), url: recipeUrl))
        }
        
        return recipes
    }
}
