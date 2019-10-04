//
//  FoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AvailableFoodCell: FoodCell {

    @IBOutlet weak var weightLbl: UILabel!
    
    func updateViews(foodItem: FoodItem) {
        guard let food = foodItem.food else { return }
        
        
        super.updateViews(food: food)
        
        if SettingsService.instance.userInfo.lbsMetrics {
            weightLbl.text = "\(truncateDoubleTail(convertMetrics(g: foodItem.available ?? 0))) \(LB)"
        } else {
            weightLbl.text = "\(Int(foodItem.available ?? 0)) \(G)"
        }
    }
}
