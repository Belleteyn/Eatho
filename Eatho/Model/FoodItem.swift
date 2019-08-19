//
//  FoodItem.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FoodItem: Codable {
    
    var food: Food?
    var availableWeight: Double?
    var delta: Double?
    var portion: Double?
    
    private (set) public var weightMeasure: String?

    var dailyPortion: DailyPortion
    
    init(json: JSON) {
        let food = json["food"]
        self.food = Food(json: food)
        self.availableWeight = json["available"].double
        self.delta = json["delta"].double
        self.portion = json["portion"].double
        self.weightMeasure = json["measure"].string
        
        self.dailyPortion = DailyPortion(json: json["dailyPortion"])
    }
    
    init(name: String, type: String,
         availableWeight: Double,
         nutrition: NutritionFacts, gi: Int = 0,
         dailyPortion: DailyPortion,
         weightMeasure: String = "g") {

        self.food = Food(name: name, type: type, nutrition: nutrition, gi: gi)
        self.availableWeight = availableWeight
        self.dailyPortion = dailyPortion
        self.weightMeasure = weightMeasure
    }
    
    mutating func updateWeight(delta: Double) {
        if portion != nil {
            portion! += delta
        } else {
            portion = delta
        }
    }
}

struct DailyPortion: Codable {
    var min: Int?
    var max: Int?
    var preferred: Int?
    
    init(json: JSON) {
        self.min = json["min"].int
        self.max = json["max"].int
        self.preferred = json["preferred"].int
    }
    
    init(min: Int, max: Int, preferred: Int) {
        self.min = min
        self.max = max
        self.preferred = preferred
    }
}
