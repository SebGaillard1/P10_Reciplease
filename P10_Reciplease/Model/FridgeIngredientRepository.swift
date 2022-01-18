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
    let viewContext: NSManagedObjectContext
    
    //MARK: - Init
    init(viewContext: NSManagedObjectContext = CoreDataStack.sharedInstance.viewContext) {
        self.viewContext = viewContext
    }
    
    //MARK: - Alert Notification
    private func alertNotification(message: String) {
        let alertName = Notification.Name("alert")
        NotificationCenter.default.post(name: alertName, object: nil, userInfo: ["message": message])
    }
    
    //MARK: - Repository
    func saveFridgeIngredient(named name: String, completion: (_ success: Bool) -> Void) {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            completion(false)
            return
        }
        
        let ingredient = FridgeIngredient(context: viewContext)
        ingredient.name = name
        
        do {
            try viewContext.save()
            completion(true)
        } catch {
            self.alertNotification(message: "Unable to save \(name)")
            completion(false)
        }
    }
    
    func getFridgeIngredients(completion: (_ success: Bool, _ ingredients: [FridgeIngredient]) -> Void) {
        let request: NSFetchRequest<FridgeIngredient> = FridgeIngredient.fetchRequest()
        
        guard let ingredients = try? viewContext.fetch(request) else {
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
                    viewContext.delete(ingredient)
                }
            } else {
                self.alertNotification(message: "Error while retrieving fridge ingredients")
                completion(false)
            }
        }
        
        do {
            try viewContext.save()
            completion(true)
        } catch {
            completion(false)
            self.alertNotification(message: "Unable to remove the ingredients")
        }
    }
    
    func removeIngredient(ingredient: FridgeIngredient, completion: (_ success: Bool) -> Void) {
        viewContext.delete(ingredient)
        
        do {
            try viewContext.save()
            completion(true)
        } catch {
            completion(false)
            self.alertNotification(message: "Unable to remove the ingredient!")
        }
    }
}
