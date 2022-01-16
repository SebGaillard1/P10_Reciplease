//
//  UIView+addGradient.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 16/01/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func addBlackGradient() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight:CGFloat = height/2.5
        let shadow = UIColor.black.withAlphaComponent(1).cgColor

        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        self.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}
