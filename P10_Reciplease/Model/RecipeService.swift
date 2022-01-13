//
//  RecipeService.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import Alamofire

class RecipeService {
    
    private let url = "https://api.edamam.com/api/recipes/v2"
    private let appId = "490915d3"
    private let appKey = "6eb213ece561751aedcd1e4aa3a02dc8"
    private let type = "public"
    
    private let q = "chicken"
    
    func fetchRecipes() {
        let parameters: [String: String] = ["app_id": appId, "app_key": appKey, "type": type, "q": q]
        
        AF.request(url, parameters: parameters).validate().responseDecodable(of: Welcome.self) { response in
            guard let recipes = response.value else {
                print("Erroooooor")
                return
            }
            let title = recipes.hits[0].recipe.label
            print(title)
        }
    }
    
}
