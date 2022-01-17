//
//  Recipe.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation

// MARK: - Welcome
struct RecipeData: Codable {
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: RecipeType
    let links: HitLinks
}

// MARK: - Recipe
struct RecipeType: Codable {
    let label: String
    let image: String
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [IngredientType]
    let calories: Double
    let totalWeight: Double
    let totalTime: Double
    let cuisineType: [String]
    let url: String
}

// MARK: - Ingredient
struct IngredientType: Codable {
    let text: String
    let quantity: Double
    let measure: String?
    let food: String
    let weight: Double
    let foodCategory: String?
    let foodID: String

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
    }
}

// MARK: - HitLinks
struct HitLinks: Codable {
    let linksSelf: Next

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Next
struct Next: Codable {
    let href: String
}
