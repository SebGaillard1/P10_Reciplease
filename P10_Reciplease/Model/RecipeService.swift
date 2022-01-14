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
    private let url = "https://api.edamam.com/api/recipes/v2"
    private let appId = "490915d3"
    private let appKey = "6eb213ece561751aedcd1e4aa3a02dc8"
    private let type = "public"
    
    private let recipeRepository = RecipeRepository()
        
    //MARK: - Public
    func fetchRecipes(withIngredients ingredients: [Ingredient], completion: @escaping (_ success: Bool, _ recipes: [RecipeModel]) -> Void) {
        let ingredients = getIngredientsString(from: ingredients)
        
        let parameters: [String: String] = ["app_id": appId, "app_key": appKey, "type": type, "q": ingredients]
        
        AF.request(url, parameters: parameters).validate().responseDecodable(of: RecipeData.self) { response in
            guard let recipesData = response.value else {
                completion(false, [])
                return
            }
            
            self.createRecipes(withData: recipesData) { recipes in
                completion(true, recipes)
            }
        }
    }
    
    //MARK: - Private
    private init() {}
    
    private func getIngredientsString(from ingredients: [Ingredient]) -> String {
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
    
    private func createRecipes(withData data: RecipeData, completion: (_ recipes: [RecipeModel]) -> Void) {
        var allRecipes = [RecipeModel]()
        
        for oneRecipe in data.hits {
            let title = oneRecipe.recipe.label
            var allIngredients = ""
            for ingredient in oneRecipe.recipe.ingredients {
                allIngredients += "\(ingredient.food), "
            }
            let rate = "5/5"
            let imageUrl = oneRecipe.recipe.image
            let duration = oneRecipe.recipe.totalTime
            self.getImage(from: imageUrl) { recipeImage in
                allRecipes.append(RecipeModel(title: title, ingredient: allIngredients, rate: rate, image: recipeImage, duration: duration))
            }
        }
    }
}
