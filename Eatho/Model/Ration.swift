//
//  RationItem.swift
//  Eatho
//
//  Created by Серафима Зыкова on 08/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Ration: Codable {
    var date = ""
    var nutrition = NutritionFacts(calories: 0, proteins: 0, carbs: 0, fats: 0)
    var error = Dictionary<String, Double>()
    var ration = [FoodItem]()
    
    init(json: JSON) {
        self.date = json["date"].string ?? ""
        
        self.nutrition = NutritionFacts(json: json["nutrition"])
        
        if let err = json["error"].dictionaryObject as? Dictionary<String, Double> {
            self.error = err
        }
        
        if let rationArr = json["ration"].array {

            for item in rationArr {
                self.ration.append(FoodItem(json: item))
            }
        }
    }
}
