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
    let ingredients: [RecipeIngredientModel]
    let rate: String
    let image: UIImage
    let imageUrl: String
    let duration: Double
    let url: String
    
    var simpleIngredientsList: String {
        var string = ""
        for ingredient in ingredients {
            string += "\(ingredient.food.capitalized), "
        }
        string.removeLast()
        string.removeLast()
        return string
    }
    
    var detailIngredientsList: String {
        var string = ""
        for ingredient in ingredients {
            string += "- \(ingredient.text)\n"
        }
        return string
    }
}

struct RecipeIngredientModel {
    let text: String
    let quantity: Double
    let measure: String
    let food: String
    let weight: Double
    let foodCategory: String
}
