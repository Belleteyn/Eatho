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
    
    override func updateViews(foodItem: FoodItem) {
        super.updateViews(foodItem: foodItem)
        
        portionTxt.text = "\(foodItem.delta) g"
        
        let caloriesPerPortion = round(Double(foodItem.portion) * foodItem.calories / 100)
        super.info.text = "\(foodItem.portion) g (\(Int(caloriesPerPortion)) kcal)"
        
        increaseBtn.isEnabled = (foodItem.availableWeight > Double(foodItem.portion))
        decreaseBtn.isEnabled = (foodItem.portion > 0)
    }

    @IBAction func decreaseBtnClick(_ sender: Any) {
        RationService.instance.decPortion(name: super.name.text!)
    }
    
    @IBAction func increaseBtnClick(_ sender: Any) {
        RationService.instance.incPortion(name: super.name.text!)
    }
}
