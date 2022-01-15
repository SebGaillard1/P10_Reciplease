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
    let duration: Double
    let url: String
    
    var simpleIngredientsList: String {
        var string = ""
        for ing in ingredients {
            string += "\(ing.food.capitalized), "
        }
        return string
    }
    
    var detailIngredientsList: String {
        var string = ""
        for ing in ingredients {
            string += "- \(ing.text)\n\n"
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
