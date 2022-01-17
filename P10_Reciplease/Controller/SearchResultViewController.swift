//
//  SearchResultViewController.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import UIKit

class SearchResultViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var resultRecipesTableView: UITableView!
    
    //MARK: - Properties
    var recipes = [RecipeModel]()
    var nextPageUrl: String?
    
    private var selectedRecipeIndex: Int?
    private let cellId = "SearchResultTableViewCell"
    
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
        
        resultRecipesTableView.dataSource = self
        resultRecipesTableView.delegate = self
        resultRecipesTableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipeDetails" {
            guard let selectedRecipe = selectedRecipeIndex else { return }
            guard let destinationVC = segue.destination as? RecipeDetailsViewController else { return }
            destinationVC.recipe = recipes[selectedRecipe]
        }
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.recipeTitleLabel.text = recipes[indexPath.row].title
        cell.recipeIngredientsLabel.text = recipes[indexPath.row].simpleIngredientsList
        cell.recipeRateLabel.text = "👍\(recipes[indexPath.row].rate)"
        cell.recipeTimeLabel.text = "\(recipes[indexPath.row].duration.getStringFormattedTime())"
        cell.recipeImageView.image = recipes[indexPath.row].image
        cell.recipeImageView.contentMode = .scaleAspectFill
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeIndex = indexPath.row
        performSegue(withIdentifier: "segueToRecipeDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == indexPath.last {
            print("derniere cellule")
        }
    }
}
