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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(title: String, ingredients: String, image: UIImage, rate: String?, time: String?) {
        recipeTitleLabel.text = title
        recipeIngredientsLabel.text = ingredients
        recipeImageView.image = image
        recipeRateLabel.text = rate
        recipeTimeLabel.text = time
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
