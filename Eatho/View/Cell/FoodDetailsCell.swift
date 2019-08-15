//
//  FoodDetailsCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 14/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class FoodDetailsCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var per100gLbl: UILabel!
    @IBOutlet weak var perPortionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initData(nutrient: Nutrient) {
        nameLbl.text = nutrient.name
        per100gLbl.text = "\(nutrient.per100g)"
        perPortionLbl.text = "\(nutrient.perPorition)"
    }
}
