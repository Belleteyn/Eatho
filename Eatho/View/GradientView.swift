//
//  GradientView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 22/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    //called after setNeedsLayout
    override func layoutSubviews() {
        let gradient = CAGradientLayer()
        
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.6, y: 1)
        gradient.frame = self.bounds
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}
