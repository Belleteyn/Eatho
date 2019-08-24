//
//  FoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    
    @IBOutlet weak var proteins: UILabel!
    @IBOutlet weak var fats: UILabel!
    @IBOutlet weak var carbs: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        cardView.layer.cornerRadius = 6.0
        cardView.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
    func updateViews(food: Food) {
        icon.image = UIImage(named: food.icon)
        name.text = food.name
        
        proteins.text = "\(food.nutrition.proteins ?? 0) g"
        carbs.text = "\(food.nutrition.carbs.total ?? 0) g"
        fats.text = "\(food.nutrition.fats.total ?? 0) g"
    }
}
