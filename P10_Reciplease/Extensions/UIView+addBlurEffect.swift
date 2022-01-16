//
//  UIView+addBlurEffect.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 16/01/2022.
//

import Foundation
import UIKit

extension UIView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        self.addSubview(blurEffectView)
    }
}
