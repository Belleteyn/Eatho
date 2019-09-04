//
//  RationInsertionFoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 03/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationInsertionFoodCell: FoodCell {
    
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var foodItem: FoodItem?
    
    func updateViews(foodItem: FoodItem) {
        self.foodItem = foodItem
        guard let food = foodItem.food else { return }
        super.updateViews(food: food)
        
        weightLbl.text = "\(Int(foodItem.available ?? 0)) \(foodItem.weightMeasure ?? "g")"
        info.text = "\(foodItem.food!.nutrition.calories.total ?? 0) kkal (100 g)"
        
        //todo: set checked if it is in ration
        if (foodItem.dailyPortion.min ?? 0) > 0 {
            addButton.setImage(UIImage(named: "content_item_checked.png"), for: .normal)
        } else {
            addButton.setImage(UIImage(named: "content_item_add_to_ration.png"), for: .normal)
        }
    }
    
    @IBAction func onAddBtnClicked(_ sender: Any) {
        guard let food = foodItem else { return }
        NotificationCenter.default.post(name: NOTIF_PRESENT_RATION_COMPLEMENT_MODAL, object: nil, userInfo: ["food": food])
    }
}
