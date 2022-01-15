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
        
        ingredientRepository.saveFridgeIngredient(named: ingredientName.capitalized) { success in
            if success {
                getIngredient()
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
        ingredientRepository.removeAllIngredient { success in
            if success {
                ingredientsArray.removeAll()
                ingredientTableView.reloadData()
            }
        }
    }
    
    private func fetchRecipes() {
        searchForRecipesButton.isEnabled = false
        activityIndictor.isHidden = false
        
        RecipeService.shared.fetchRecipes(withIngredients: ingredientsArray) { success, recipes  in
            if success {
                self.recipes = recipes
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientTableViewCell else { return UITableViewCell() }
        
        guard let ingredientName = ingredientsArray[indexPath.row].name else { return UITableViewCell() }
        cell.configure(title: " - \(ingredientName)")
        
        return cell
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredient()
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}
