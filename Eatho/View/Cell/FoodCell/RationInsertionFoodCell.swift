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
    var addBtnState = false //not checked
    
    var openModalHandler: ((_: FoodItem) -> ())?
    var removeHandler: ((_: String) -> ())?
    
    override func awakeFromNib() {
        weightLbl.font = MEDIUM_FONT
    }
    
    func updateViews(foodItem: FoodItem, removeHandler: @escaping (_ id: String) -> (), openModalHandler: @escaping (_: FoodItem) -> ()) {
        self.foodItem = foodItem
        self.removeHandler = removeHandler
        self.openModalHandler = openModalHandler
        
        guard let food = foodItem.food else { return }
        super.updateViews(food: food)
        
        if SettingsService.instance.userInfo.lbsMetrics {
            weightLbl.text = "\(truncateDoubleTail(convertMetrics(g: foodItem.available ?? 0))) \(LB)"
        } else {
            weightLbl.text = "\(Int(foodItem.available ?? 0)) \(G)"
        }
        
        if RationService.instance.isFoodContainedInCurrentRation(id: food._id!) {
            addButton.setImage(UIImage(named: "content_item_checked.png"), for: .normal)
            addBtnState = true
        } else {
            addButton.setImage(UIImage(named: "content_item_add_to_ration.png"), for: .normal)
            addBtnState = false
        }
    }
    
    @IBAction func onAddBtnClicked(_ sender: Any) {
        guard let foodItem = foodItem, let food = foodItem.food, let id = food._id else { return }
        
        if addBtnState {
            if let removeHandler = removeHandler {
                removeHandler(id)
            }
        } else {
            if let openModalHandler = openModalHandler {
                openModalHandler(foodItem)
            }
        }
    }
}
