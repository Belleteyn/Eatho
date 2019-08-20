//
//  SearchFoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 20/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SearchFoodCell: FoodCell {

    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateViews(food: Food) {
        super.updateViews(food: food)
        self.id = food._id ?? ""
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_SEARCH_FOOD_ADD, object: nil)
        DataService.instance.addFoodToAvailable(forId: id!, available: 0, dailyPortion: DailyPortion(min: 0, max: 0, preferred: 0)) { (success) in
            NotificationCenter.default.post(name: NOTIF_SEARCH_FOOD_ADD_DONE, object: nil, userInfo: ["success": success])
        }
    }

}
