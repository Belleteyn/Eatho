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
    
    private var addButtonState: Bool = false
    
    override func updateViews(foodItem: FoodItem) {
        super.updateViews(foodItem: foodItem)
        
        addButtonState = foodItem.selectionState
        
        weightLbl.text = "\(Int(foodItem.availableWeight)) \(foodItem.weightMeasure)"
        info.text = "\(foodItem.calories) kkal (100 g)"
    }

    @IBAction func onAddBtnClicked(_ sender: Any) {
        addButtonState = !addButtonState
        
        if (addButtonState) {
            addButton.setImage(UIImage(named: "content_item_checked.png"), for: .normal)
        } else {
            addButton.setImage(UIImage(named: "content_item_add_to_ration.png"), for: .normal)
        }
    }
}
