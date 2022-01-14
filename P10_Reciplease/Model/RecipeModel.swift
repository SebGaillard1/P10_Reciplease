//
//  RecipeModel.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 14/01/2022.
//

import Foundation
import UIKit

struct RecipeModel {
    let title: String
    let ingredient: [IngredientModel]
    let rate: String
    let image: UIImage
    let duration: Double
    
    var ingredientListAsString: String {
        var string = ""
        for ing in ingredient {
            string += "\(ing.food.capitalized), "
        }
        return string
    }
}

struct IngredientModel {
    let text: String
    let quantity: Double
    let measure: String
    let food: String
    let weight: Double
    let foodCategory: String
}
