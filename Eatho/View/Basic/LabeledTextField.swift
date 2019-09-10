//
//  LabeledTextField.swift
//  Eatho
//
//  Created by Серафима Зыкова on 03/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

@IBDesignable
class LabeledTextField: UITextField, UITextViewDelegate {

    @IBInspectable var lbl: String = "" {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var offset: CGFloat = 16 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let height = self.frame.height
        let width = self.frame.width / 2
        let label = UILabel(frame: CGRect(x: Double(self.frame.width - width - offset), y: 0.0, width: Double(width), height: Double(height)))
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        label.attributedText = NSAttributedString(string: lbl, attributes: [NSAttributedString.Key.foregroundColor : LIGHT_TEXT_COLOR, NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(14))])
        label.textAlignment = NSTextAlignment.right

        self.addSubview(label)
    }
}
