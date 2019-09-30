//
//  SearchFoodCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 20/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SearchFoodCell: FoodCell {

    @IBOutlet weak var insertionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateViews(food: Food) {
        guard let id = food._id else { return }
        
        self.id = id
        super.updateViews(food: food)
        
        if FoodService.instance.foods.contains(where: { $0.food?._id == food._id } ) {
            insertionButton.setImage(UIImage(named: "content_item_checked.png"), for: UIControl.State.normal)
        }
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_SEARCH_FOOD_ADD, object: nil)
        
        FoodService.instance.insert(forId: id!, available: 0, dailyPortion: DailyPortion(min: 0, max: 0)) { (_, error) in
            NotificationCenter.default.post(name: NOTIF_SEARCH_FOOD_ADD_DONE, object: nil, userInfo: ["success": error == nil])
        }
    }

}
