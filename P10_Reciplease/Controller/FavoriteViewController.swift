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
    @IBOutlet weak var noRecipeLabel: UILabel!
    
    //MARK: - Properties
    private let cellId = "SearchResultTableViewCell"
    
    private let favoriteRecipeRepository = FavoriteRecipeRepository()
    private var selectedRecipe = 0
    private var favoriteRecipes = [RecipeModel]() {
        didSet {
            if favoriteRecipes.isEmpty {
                noRecipeLabel.isHidden = false
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                noRecipeLabel.isHidden = true
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
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
        
        noRecipeLabel.text = "No favorite recipe 😩 \n\n\nTry to add a recipe to your favorites by tapping the star button in a recipe ! ⭐️"
        noRecipeLabel.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height)

        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        favoriteTableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(removeAllFavorites))
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
    
    @objc func removeAllFavorites() {
        let alertController = UIAlertController(title: "Remove all", message: "You are about to remove ALL of your favorites recipes. Are you sure you want to remove all recipes from your favorites ?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, remove them", style: .destructive, handler: { _ in
            self.favoriteRecipeRepository.removeAllFavoriteRecipes { success in
                if success {
                    self.favoriteRecipes.removeAll()
                    self.favoriteTableView.reloadData()
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
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
        
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = indexPath.row
        performSegue(withIdentifier: "segueFromFavoriteToRecipeDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteRecipeRepository.removeFromFavorite(recipe: favoriteRecipes[indexPath.row]) { success in
                if success {
                    favoriteRecipes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
