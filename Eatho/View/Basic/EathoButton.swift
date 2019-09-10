//
//  EathoButton.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

@IBDesignable
class EathoButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 4 {
        didSet {
            self.layer.borderWidth = borderWidth / 10
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }

    func setupView() {
//        let gradient = CAGradientLayer()
//        
//        gradient.colors = [#colorLiteral(red: 0.6862745098, green: 0.5411764706, blue: 0.9294117647, alpha: 1).cgColor, #colorLiteral(red: 0.5450980392, green: 0.5490196078, blue: 0.9294117647, alpha: 1).cgColor]
//        gradient.startPoint = CGPoint(x: 0.5, y: 0)
//        gradient.endPoint = CGPoint(x: 0.6, y: 1)
//        gradient.frame = self.bounds
//        
//        self.layer.insertSublayer(gradient, at: 0)
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth / 10
    }
}
