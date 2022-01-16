//
//  String+onlyLetters.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 17/01/2022.
//

import Foundation

extension String {
    func onlyLetters() -> String {
        var charset = CharacterSet.letters
        charset.insert(",")
        charset.insert(" ")
        charset = charset.inverted
        
        return components(separatedBy: charset).joined()
    }
}
