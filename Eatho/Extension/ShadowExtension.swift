//
//  ShadowExtension.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor, opacity: Float, offset: CGSize) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
    }
}
