//
//  ShadowView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 04/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.75 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var xOffset: CGFloat = 0.0 {
        didSet {
            self.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        }
    }
    
    @IBInspectable var yOffset: CGFloat = 0.0 {
        didSet {
            self.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }

    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadowOpacity
        
        self.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
    }
}
