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
    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var searchForRecipesButton: UIButton!
    
    //MARK: - Properties
    private let ingredientRepository = FridgeIngredientRepository()
    private var ingredientsArray = [FridgeIngredient]()
    
    private var recipes = [RecipeModel]()
    private var nextPageUrl = ""
    
    //MARK: - AlertController from notification
    @objc private func presentAlert(notification: Notification) {
        guard let alertMessage = notification.userInfo!["message"] as? String else { return }
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentAlert(notification:)), name: Notification.Name("alert"), object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        
        ingredientTableView.dataSource = self
        ingredientTextField.delegate = self
        
        getIngredient()
    }
    
    //MARK: - IBActions
    @IBAction func addIngredientButtonPressed(_ sender: Any) {
        addIngredient()
    }
    
    @IBAction func clearIngredientButtonPressed(_ sender: Any) {
        clearIngredient()
    }
    
    @IBAction func searchForRecipesButtonPressed(_ sender: Any) {
        fetchRecipes()
    }
    
    //MARK: - Private
    private func addIngredient() {
        guard let ingredientName = ingredientTextField.text else { return }
        
        let ingredients = ingredientName.condenseWhitespace().onlyLetters().components(separatedBy: ",")
        for ingredient in ingredients {
            ingredientRepository.saveFridgeIngredient(named: ingredient.trimmingCharacters(in: .whitespaces).capitalized) { success in
                if success {
                    ingredientTextField.text = ""
                    getIngredient()
                }
            }
        }
    }
    
    private func getIngredient() {
        ingredientRepository.getFridgeIngredients { success, ingredients  in
            if success {
                ingredientsArray = ingredients
                ingredientTableView.reloadData()
            }
        }
    }
    
    private func clearIngredient() {
        ingredientRepository.removeAllIngredients { success in
            if success {
                ingredientsArray.removeAll()
                ingredientTableView.reloadData()
            }
        }
    }
    
    private func fetchRecipes() {
        searchForRecipesButton.isEnabled = false
        activityIndictor.isHidden = false
        
        RecipeService.shared.fetchRecipes(atUrl: RecipeService.baseUrl, withIngredients: ingredientsArray) { success, recipes, nextPageUrl  in
            if success {
                self.recipes = recipes
                self.nextPageUrl = nextPageUrl ?? ""
                self.performSegue(withIdentifier: "segueToSearchResult", sender: self)
            }
            self.searchForRecipesButton.isEnabled = true
            self.activityIndictor.isHidden = true
        }
    }
    
    //MARK: - Public
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSearchResult" {
            let destinationVC = segue.destination as! SearchResultViewController
            destinationVC.recipes = recipes
            destinationVC.nextPageUrl = nextPageUrl
        }
    }
    
    @objc func hideKeyboard() {
        ingredientTextField.resignFirstResponder()
    }
}

//MARK: - Extensions
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        guard let ingredientName = ingredientsArray[indexPath.row].name else { return UITableViewCell() }
        
        var content = cell.defaultContentConfiguration()
        content.text = ingredientName
        cell.contentConfiguration = content
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientRepository.removeIngredient(ingredient: ingredientsArray[indexPath.row]) { success in
                if success {
                    ingredientsArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredient()
        textField.resignFirstResponder()
        return true
    }
}
