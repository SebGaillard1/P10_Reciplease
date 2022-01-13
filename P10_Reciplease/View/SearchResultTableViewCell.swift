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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
}
