//
//  FoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AvailableFoodCell: FoodCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var weightLbl: UILabel!
    
    override func updateViews(foodItem: FoodItem) {
        super.updateViews(foodItem: foodItem)
        
        weightLbl.text = "\(Int(foodItem.availableWeight)) \(foodItem.weightMeasure)"
        info.text = "\(foodItem.calories) kkal (100 g)"
        
        if foodItem.min > 0 {
            addButton.setImage(UIImage(named: "content_item_checked.png"), for: .normal)
        } else {
            addButton.setImage(UIImage(named: "content_item_add_to_ration.png"), for: .normal)
        }
    }

    @IBAction func onAddBtnClicked(_ sender: Any) {
        DataService.instance.setSelected(name: super.name.text!)
    }
}
