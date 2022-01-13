//
//  Recipe.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
}
// MARK: - Recipe
struct Recipe: Codable {
    let label: String
    let image: String?
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [Ingrediento]
    let calories: Double
    let totalWeight: Double
    let totalTime: Int
    let cuisineType: [String]
}

// MARK: - Ingredient
struct Ingrediento: Codable {
    let text: String
    let quantity: Double
    let measure: String?
    let food: String
    let weight: Double
    let foodCategory: String?
    let foodID: String
    let image: String?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}
