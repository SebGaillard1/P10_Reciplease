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
    
    private let favoriteRecipeRepository = FavoriteRecipeRepository()
    private let recipeIngredientRepository = RecipeIngredientRepository()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        favoriteRecipeRepository.isRecipeAlreadyFavorite(recipe: recipe) { favorite in
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
                self.recipeIngredientRepository.saveRecipeIngredients(forRecipe: recipe, ingredientModel: recipe.ingredients) { success in
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
    }
    
    //MARK: - Private
    private func setupUI() {
        recipeImageImageView.image = recipe.image
        addGradient(to: recipeImageImageView)
        
        recipeTitleLabel.text = recipe.title
        recipeIngredientsLabel.text = recipe.detailIngredientsList
        recipeRateLabel.text = "👍\(recipe.rate)"
        recipeDurationLabel.text = "⏱\(recipe.duration)"
        topRightView.layer.cornerRadius = 10
    }
    
    private func addGradient(to imageView: UIImageView) {
        imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width = imageView.bounds.width
        let height = imageView.bounds.height
        let sHeight:CGFloat = height/2.5
        let shadow = UIColor.black.withAlphaComponent(1).cgColor

        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        imageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
    
}
