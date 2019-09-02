//
//  NutrientsRelativityView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 06/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class NutrientsRelativityView: UIView {
    
    private let carbsView = UIView()
    private let fatsView = UIView()
    private let proteinsView = UIView()
    
    override func awakeFromNib() {
        carbsView.backgroundColor = EATHO_RED
        fatsView.backgroundColor = EATHO_YELLOW
        proteinsView.backgroundColor = EATHO_LIGHT_PURPLE
        
        self.addSubview(carbsView)
        self.addSubview(fatsView)
        self.addSubview(proteinsView)
    }
    
    func updateView(proteinsPercent p: Double, carbsPercent c: Double, fatsPercent f: Double) {
        let viewWidth = self.frame.width
        let viewHeight = self.frame.height
        
        proteinsView.frame = CGRect(x: 0, y: 0, width: viewWidth * CGFloat(p), height: viewHeight)
        carbsView.frame = CGRect(x: proteinsView.frame.width, y: 0, width: viewWidth * CGFloat(c), height: viewHeight)
        fatsView.frame = CGRect(x: proteinsView.frame.width + carbsView.frame.width, y: 0, width: viewWidth * CGFloat(f), height: viewHeight)
        self.layoutIfNeeded()
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.proteinsView.frame = CGRect(x: 0, y: 0, width: self.proteinsView.frame.width, height: 0)
            self.carbsView.frame = CGRect(x: self.proteinsView.frame.width, y: 0, width: self.carbsView.frame.width, height: 0)
            self.fatsView.frame = CGRect(x: self.proteinsView.frame.width + self.carbsView.frame.width, y: 0, width: self.fatsView.frame.width, height: 0)
        }
    }
    
    func reveal() {
        UIView.animate(withDuration: 0.3) {
            let viewHeight = self.frame.height
            
            self.proteinsView.frame = CGRect(x: 0, y: 0, width: self.proteinsView.frame.width, height: viewHeight)
            self.carbsView.frame = CGRect(x: self.proteinsView.frame.width, y: 0, width: self.carbsView.frame.width, height: viewHeight)
            self.fatsView.frame = CGRect(x: self.proteinsView.frame.width + self.carbsView.frame.width, y: 0, width: self.fatsView.frame.width, height: viewHeight)
        }
    }
}
