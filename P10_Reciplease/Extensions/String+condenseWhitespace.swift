//
//  String+condenseWhitespace.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 17/01/2022.
//

import Foundation

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func onlyValidCharacters() -> String {
        var charset = CharacterSet.alphanumerics
        charset.insert(",")
        charset.insert(" ")
        charset = charset.inverted
        
        return components(separatedBy: charset).joined()
    }
}
