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
    
    var incPortionHandler: ((_: String) -> ())?
    var decPortionHandler: ((_: String) -> ())?
    
    func updateViews(foodItem: FoodItem) {
        guard let food = foodItem.food else { return }
        super.updateViews(food: food)
        
        let portion = foodItem.portion ?? 0
        
        let caloriesPerPortion = round(portion * (food.nutrition.calories.total ?? 0) / 100)
        if SettingsService.instance.userInfo.lbsMetrics {
            super.info.text = "\(truncateDoubleTail(convertMetrics(g: portion))) \(LB) (\(Int(caloriesPerPortion)) \(KCAL))"
        } else {
            super.info.text = "\(Int(portion)) \(G) (\(Int(caloriesPerPortion)) \(KCAL))"
        }
        
        portionTxt.isHidden = true
        increaseBtn.isHidden = true
        decreaseBtn.isHidden = true
    }
    
    func updateViews(foodItem: FoodItem, editable: Bool, incPortionHandler: @escaping ((_: String) -> ()), decPortionHandler: @escaping ((_: String) -> ())) {
        
        self.decPortionHandler = decPortionHandler
        self.incPortionHandler = incPortionHandler
        
        updateViews(foodItem: foodItem)
    
        let portion = foodItem.portion ?? 0
        if editable {
            let delta = foodItem.delta ?? 0
            if SettingsService.instance.userInfo.lbsMetrics {
                portionTxt.text = "\(truncateDoubleTail(convertMetrics(g: delta))) \(LB)"
            } else {
                portionTxt.text = "\(delta) \(G)"
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
        if let handler = decPortionHandler, let id = super.id {
            handler(id)
        }
    }
    
    @IBAction func increaseBtnClick(_ sender: Any) {
        if let handler = incPortionHandler, let id = super.id {
            handler(id)
        }
    }
}
