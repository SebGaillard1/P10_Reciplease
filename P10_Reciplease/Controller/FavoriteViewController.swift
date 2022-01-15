//
//  FavoriteViewController.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 14/01/2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var favoriteTableView: UITableView!

    //MARK: - Properties
    private let cellId = "SearchResultTableViewCell"
    
    private var favoriteRecipes = [RecipeModel]()
    private let favoriteRecipeRepository = FavoriteRecipeRepository()
    private var selectedRecipe = 0
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        favoriteTableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
//        favoriteRecipeRepository.removeAllFavoriteRecipes { _ in
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        favoriteRecipeRepository.getFavoriteRecipiesWithUIImage { success, recipies in
            if success {
                favoriteRecipes = recipies
                favoriteTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromFavoriteToRecipeDetails" {
            let destinationVC = segue.destination as! RecipeDetailsViewController
            destinationVC.recipe = favoriteRecipes[selectedRecipe]
        }
    }
}

//MARK: - Extensions

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.recipeTitleLabel.text = favoriteRecipes[indexPath.row].title
        cell.recipeIngredientsLabel.text = favoriteRecipes[indexPath.row].simpleIngredientsList
        cell.recipeRateLabel.text = "👍\(favoriteRecipes[indexPath.row].rate)"
        cell.recipeTimeLabel.text = "⏱\(favoriteRecipes[indexPath.row].duration)"
        cell.recipeImageView.image = favoriteRecipes[indexPath.row].image
        cell.recipeImageView.contentMode = .scaleAspectFill
        cell.recipeImageView.addGradient()
        
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = indexPath.row
        performSegue(withIdentifier: "segueFromFavoriteToRecipeDetails", sender: self)
    }
}
