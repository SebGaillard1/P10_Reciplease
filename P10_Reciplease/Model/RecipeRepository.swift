//
//  RecipeRepository.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation

final class RecipeRepository {
    //MARK: - Properties
    private let coreDataStack: CoreDataStack
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
}
