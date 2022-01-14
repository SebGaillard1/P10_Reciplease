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
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        favoriteTableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        addGradient(to: cell.recipeImageView)
        
        return cell
    }
    
    
}

extension FavoriteViewController: UITableViewDelegate {
    
}
