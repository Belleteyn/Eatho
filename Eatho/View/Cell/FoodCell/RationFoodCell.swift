//
//  RaionFoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationFoodCell: FoodCell {

    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var portionTxt: UILabel!
    
    func updateViews(foodItem: FoodItem, editable: Bool) {
        guard let food = foodItem.food else { return }
        
        super.updateViews(food: food)
        
        let portion = foodItem.portion ?? 0
        
        let caloriesPerPortion = round(portion * (food.nutrition.calories.total ?? 0) / 100)
        if SettingsService.instance.userInfo.lbsMetrics {
            super.info.text = "\(truncateDoubleTail(convertMetrics(g: portion))) lbs (\(Int(caloriesPerPortion)) kcal)"
        } else {
            super.info.text = "\(Int(portion)) g (\(Int(caloriesPerPortion)) kcal)"
        }
        
        
        if editable {
            let delta = foodItem.delta ?? 0
            if SettingsService.instance.userInfo.lbsMetrics {
                portionTxt.text = "\(truncateDoubleTail(convertMetrics(g: delta))) lbs"
            } else {
                portionTxt.text = "\(delta) g"
            }
            
            increaseBtn.isEnabled = ((foodItem.available ?? 0) > portion)
            decreaseBtn.isEnabled = (portion > 0)
            
            portionTxt.isHidden = false
            increaseBtn.isHidden = false
            decreaseBtn.isHidden = false
        } else {
            portionTxt.isHidden = true
            increaseBtn.isHidden = true
            decreaseBtn.isHidden = true
        }
    }

    @IBAction func decreaseBtnClick(_ sender: Any) {
        RationService.instance.decPortion(name: super.name.text!)
    }
    
    @IBAction func increaseBtnClick(_ sender: Any) {
        RationService.instance.incPortion(name: super.name.text!)
    }
}
