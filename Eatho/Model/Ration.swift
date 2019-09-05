//
//  RationItem.swift
//  Eatho
//
//  Created by Серафима Зыкова on 08/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Ration {
    var date = ""
    var nutrition = Nutrition(calories: 0, proteins: 0, carbs: 0, fats: 0)
    var error = Dictionary<String, Double>()
    var ration = [FoodItem]()
    
    init(json: JSON) throws {
        guard let date = json["date"].string else { throw DataParseError.corruptedData }
        self.date = date
        
        do {
            self.nutrition = try Nutrition(NutritionFacts(json: json["nutrition"]))
        } catch let err {
            throw err
        }
        
        if let err = json["error"].dictionaryObject as? Dictionary<String, Double> {
            self.error = err
        }
        
        if let rationArr = json["ration"].array {
            for item in rationArr {
                self.ration.append(FoodItem(json: item))
            }
        }
    }
    
    func toJson() -> JSON {
        do {
            let ration = try JSON(JSONEncoder().encode(self.ration))
            let json: JSON = [
                "date": self.date,
                "nutrition": [
                    "calories": [ "total": self.nutrition.calories ],
                    "proteins": self.nutrition.proteins,
                    "carbs": [ "total": self.nutrition.carbs ],
                    "fats": [ "total": self.nutrition.fats ],
                ],
                "error": self.error,
                "ration": ration
            ]
            return json
        } catch let err {
            print(err)
        }
        
        return JSON()
    }
}
