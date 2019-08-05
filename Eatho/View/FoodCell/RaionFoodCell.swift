//
//  RaionFoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RaionFoodCell: FoodCell {

    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var portionTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func updateViews(foodItem: FoodItem) {
        super.updateViews(foodItem: foodItem)
    }

    @IBAction func decreaseBtnClick(_ sender: Any) {
    }
    
    @IBAction func increaseBtnClick(_ sender: Any) {
    }
}
