//
//  IngredientRepository.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import Foundation
import CoreData

final class FridgeIngredientRepository {
    //MARK: - Properties
    private let coreDataStack: CoreDataStack
    
    //MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    //MARK: - Alert Notification
    private func alertNotification(message: String) {
        let alertName = Notification.Name("alert")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    }
    
    //MARK: - Repository
    func saveFridgeIngredient(named name: String, completion: (_ success: Bool) -> Void) {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.alertNotification(message: "Enter ingredient before adding")
            completion(false)
            return
        }
        
        let ingredient = FridgeIngredient(context: coreDataStack.viewContext)
        ingredient.name = name
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            self.alertNotification(message: "Unable to save \(name)")
            completion(false)
        }
    }
    
    func getFridgeIngredients(completion: (_ success: Bool, _ ingredients: [FridgeIngredient]) -> Void) {
        let request: NSFetchRequest<FridgeIngredient> = FridgeIngredient.fetchRequest()
        
        guard let ingredients = try? coreDataStack.viewContext.fetch(request) else {
            self.alertNotification(message: "Error while retrieving fridge ingredients")
            completion(false, [])
            return
        }
        
        completion(true, ingredients)
    }
    
    func removeAllIngredients(completion: (_ success: Bool) -> Void) {
        getFridgeIngredients { success, ingredients in
            if success {
                for ingredient in ingredients {
                    coreDataStack.viewContext.delete(ingredient)
                }
            } else {
                self.alertNotification(message: "Error while retrieving fridge ingredients")
                completion(false)
            }
        }
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            completion(false)
            self.alertNotification(message: "Unable to remove the ingredients")
        }
    }
    
    func removeIngredient(ingredient: FridgeIngredient, completion: (_ success: Bool) -> Void) {
        coreDataStack.viewContext.delete(ingredient)
        
        do {
            try coreDataStack.viewContext.save()
            completion(true)
        } catch {
            completion(false)
            self.alertNotification(message: "Unable to remove the ingredient!")
        }
    }
}
