//
//  RecipeDetailsViewController.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 14/01/2022.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var recipeImageImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var recipeRateLabel: UILabel!
    @IBOutlet weak var recipeDurationLabel: UILabel!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    //MARK: - Properties
    var recipe: RecipeModel!
    
    private let favoriteRecipeRepository = FavoriteRecipeRepository(coreDataStack: CoreDataStack.sharedInstance)
    private let recipeIngredientRepository = RecipeIngredientRepository(coreDataStack: CoreDataStack.sharedInstance)
    
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
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteRecipeRepository.isRecipeFavorite(recipe: recipe) { favorite in
            if favorite {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(removeFavorite))
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(setFavorite))
            }
        }
    }
    
    @objc func setFavorite() {
        favoriteRecipeRepository.saveRecipeAsFavorite(recipe: recipe) { success in
            if success {
                self.recipeIngredientRepository.saveRecipeIngredients(forRecipe: recipe, ingredientsModel: recipe.ingredients) { success in
                    if success {
                        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(removeFavorite))
                    }
                }
            }
        }
    }
    
    @objc func removeFavorite() {
        favoriteRecipeRepository.removeFromFavorite(recipe: recipe) { success in
            if success {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(setFavorite))
            }
        }
    }
    
    @IBAction func getDirectionsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "detailsToDirectionSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsToDirectionSegue" {
            let destinationVC = segue.destination as! DirectionWebViewController
            destinationVC.url = recipe.url
        }
    }
    
    //MARK: - Private
    private func setupUI() {
        recipeImageImageView.image = recipe.image
        recipeTitleLabel.text = recipe.title
        recipeIngredientsLabel.text = recipe.detailIngredientsList
        recipeRateLabel.text = "👍\(recipe.rate)"
        recipeDurationLabel.text = "\(recipe.duration.getStringFormattedTime())"
        topRightView.layer.cornerRadius = 10
        topRightView.addBlurEffect()
        recipeImageImageView.addBlackGradient()
    }
}
