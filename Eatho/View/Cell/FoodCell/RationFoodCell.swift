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
    
    func updateViews(foodItem: FoodItem) {
        guard let food = foodItem.food else { return }
        
        super.updateViews(food: food)
        
        let portion = foodItem.portion ?? 0
        portionTxt.text = "\(foodItem.delta ?? 0) g"
        
        let caloriesPerPortion = round(portion * (food.nutrition.calories.total ?? 0) / 100)
        super.info.text = "\(Int(portion)) g (\(Int(caloriesPerPortion)) kcal)"
        
        increaseBtn.isEnabled = ((foodItem.available ?? 0) > portion)
        decreaseBtn.isEnabled = (portion > 0)
    }

    @IBAction func decreaseBtnClick(_ sender: Any) {
        RationService.instance.decPortion(name: super.name.text!)
    }
    
    @IBAction func increaseBtnClick(_ sender: Any) {
        RationService.instance.incPortion(name: super.name.text!)
    }
}
