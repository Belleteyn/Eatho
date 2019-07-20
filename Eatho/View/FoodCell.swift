//
//  FoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var caloriesLbl: UILabel!
    
    @IBOutlet weak var proteins: UILabel!
    @IBOutlet weak var carbs: UILabel!
    @IBOutlet weak var fats: UILabel!
    
    private var addButtonState: Bool = false
    
    func updateViews(foodItem: FoodItem) {
        icon.image = UIImage(named: foodItem.icon)
        name.text = foodItem.name
        addButtonState = foodItem.selectionState
        
        weightLbl.text = "\(Int(foodItem.weight)) \(foodItem.weightMeasure)"
        caloriesLbl.text = "\(foodItem.calories) kkal (100 g)"
        
        proteins.text = "\(foodItem.proteins) \(foodItem.pcfMeasure)"
        carbs.text = "\(foodItem.carbs) \(foodItem.pcfMeasure)"
        fats.text = "\(foodItem.fats) \(foodItem.pcfMeasure)"
        
        cardView.layer.cornerRadius = 6.0
        cardView.clipsToBounds = true
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
