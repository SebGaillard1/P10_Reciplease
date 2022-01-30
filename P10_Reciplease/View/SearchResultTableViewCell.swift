//
//  SearchResultTableViewCell.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 13/01/2022.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var recipeRateLabel: UILabel!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topRightView.layer.cornerRadius = 10
        topRightView.addBlurEffect()

        addGradient()
    }
    
    func configure(with recipe: RecipeModel) {
        recipeTitleLabel.text = recipe.title
        recipeIngredientsLabel.text = recipe.simpleIngredientsList
        recipeRateLabel.text = "👍\(recipe.rate)"
        recipeTimeLabel.text = "\(recipe.duration.getStringFormattedTime())"
        recipeImageView.image = recipe.image
        recipeImageView.contentMode = .scaleAspectFill
    }
    
    private func addGradient() {
        gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width = gradientView.bounds.width
        let height = CGFloat(200)
        let sHeight:CGFloat = height/2.5
        let shadow = UIColor.black.withAlphaComponent(1).cgColor
        
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width + 100, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        gradientView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}
