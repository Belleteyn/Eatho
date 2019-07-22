//
//  GradientView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 22/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(red: 213.0/255.0, green: 159.0/255.0, blue: 252.0/255.0, alpha: (1.0)).cgColor, UIColor(red: 143.0/255.0, green: 137.0/255.0, blue: 233.0/255.0, alpha: (1.0)).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 1)
    }
}
