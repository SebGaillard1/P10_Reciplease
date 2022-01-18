//
//  FakeResponseData.swift
//  P10_RecipleaseTests
//
//  Created by Sebastien Gaillard on 18/01/2022.
//

import Foundation

class FakeResponseData {
    //MARK: - Data
    static var recipeData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Recipes", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    
    static let incorrectData = "erreur".data(using: .utf8)
    
    //MARK: - Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    //MARK: - Error
    class FakeError: Error {}
    static let error = FakeError()
}


