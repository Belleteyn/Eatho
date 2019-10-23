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
    
    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
        name.font = BIG_FONT
        info.font = SMALL_FONT
        proteins.font = MEDIUM_FONT
        fats.font = MEDIUM_FONT
        carbs.font = MEDIUM_FONT
    }

    func setupView() {
        cardView.layer.cornerRadius = 6.0
        cardView.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
    func updateViews(food: Food) {
        id = food._id
        guard let calories = food.nutrition.calories.total else { return }
        
        name.text = food.name
        icon.image = UIImage(named: food.icon)
        
        if SettingsService.instance.userInfo.lbsMetrics {
            info.text = "\(truncateDoubleTail(kcalPerLb(kcalPerG: calories))) \(KCAL) (1 \(LB)"
        } else {
            info.text = "\(calories) \(KCAL) (100 \(G))"
        }
        
        proteins.text = "\(food.nutrition.proteins ?? 0) \(G)"
        carbs.text = "\(food.nutrition.carbs.total ?? 0) \(G)"
        fats.text = "\(food.nutrition.fats.total ?? 0) \(G)"
    }
}
