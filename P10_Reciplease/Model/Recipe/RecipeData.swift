//
//  Recipe.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation

// MARK: - Welcome
struct RecipeData: Codable {
    let links: WelcomeLinks
    let hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case hits
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: RecipeType
    let links: HitLinks

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
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

// MARK: - Recipe
struct RecipeType: Codable {
    let label: String
    let image: String
    let url: String
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories, totalWeight: Double
    let totalTime: Int
    let cuisineType: [String]

}

// MARK: - Ingredient
struct Ingredient: Codable {
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

// MARK: - WelcomeLinks
struct WelcomeLinks: Codable {
    let next: Next
}
