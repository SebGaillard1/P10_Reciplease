//
//  ViewController.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    @IBOutlet weak var clearIngredientButton: UIButton!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    //MARK: - Properties
    private let ingredientRepository = IngredientRepository()
    private var ingredientsArray = [Ingredient]()
        
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientTableView.dataSource = self
        
        getIngredient()
    }
    
    //MARK: - IBActions
    @IBAction func addIngredientButtonPressed(_ sender: Any) {
        addIngredient()
    }
    
    @IBAction func clearIngredientButtonPressed(_ sender: Any) {
        clearIngredient()
    }
    
    @IBAction func SearchForRecipesButtonPressed(_ sender: Any) {
        RecipeService.shared.fetchRecipes(withIngredients: ingredientsArray) { success in
            if success {
                self.performSegue(withIdentifier: "segueToSearchResult", sender: self)
            } else {
                
            }
        }
    }
    
    //MARK: - Private
    private func addIngredient() {
        guard let ingredientName = ingredientTextField.text else { return }
        
        ingredientRepository.saveIngredient(named: ingredientName) { success in
            if success {
                getIngredient()
            }
        }
    }
    
    private func getIngredient() {
        ingredientRepository.getIngredients { success, ingredients  in
            if success {
                ingredientsArray = ingredients
                ingredientTableView.reloadData()
            }
        }
    }
    
    private func clearIngredient() {
        ingredientRepository.removeAllIngredient { success in
            if success {
                ingredientsArray.removeAll()
                ingredientTableView.reloadData()
            }
        }
    }
    
    //MARK: - Public
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSearchResult" {
            let destinationVC = segue.destination as! SearchResultViewController
            //destinationVC.
        }
    }

}

//MARK: - Extensions
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientTableViewCell else { return UITableViewCell() }
        
        guard let ingredientName = ingredientsArray[indexPath.row].name else { return UITableViewCell() }
        cell.configure(title: " - \(ingredientName)")
        
        return cell
    }
}
