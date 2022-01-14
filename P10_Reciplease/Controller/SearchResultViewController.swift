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
    
    private let cellId = "SearchResultTableViewCell"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultRecipesTableView.dataSource = self
        resultRecipesTableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    //MARK: - Private
    private func addGradient(to imageView: UIImageView) {
        imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width = imageView.bounds.width
        let height = imageView.bounds.height
        let sHeight:CGFloat = height/2.5
        let shadow = UIColor.black.withAlphaComponent(1).cgColor

        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width + 100, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        imageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.recipeTitleLabel.text = recipes[indexPath.row].title
        cell.recipeIngredientsLabel.text = recipes[indexPath.row].ingredient
        cell.recipeRateLabel.text = "👍\(recipes[indexPath.row].rate)"
        cell.recipeTimeLabel.text = "⏱\(recipes[indexPath.row].duration)"
        cell.recipeImageView.image = recipes[indexPath.row].image
        cell.recipeImageView.contentMode = .scaleAspectFill
        addGradient(to: cell.recipeImageView)
        
        return cell
    }
}
