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
    private (set) public var _id: String?
    private (set) public var name: String?
    private (set) public var type: String?
    
    private (set) public var nutrition: NutritionFacts
    private (set) public var gi: Int?
    
    private (set) public var availableWeight: Double?
    
    private (set) public var delta: Double?
    private (set) public var portion: Double?
    
    private (set) public var weightMeasure: String?
    
    var icon: String {
        if type != nil {
            return "content_item_\(type!).png"
        } else {
            return ""
        }
    }
    
    var dailyPortion: DailyPortion
    
    init(json: JSON) {
        let food = json["food"]
        self._id = food["_id"].string
        self.name = food["name"]["en"].string
        self.type = food["type"].string
        self.gi = food["gi"].int
        self.availableWeight = json["available"].double
        self.delta = json["delta"].double
        self.portion = json["portion"].double
        self.weightMeasure = json["measure"].string
        
        self.nutrition = NutritionFacts(json: food["nutrition"])
        self.dailyPortion = DailyPortion(json: json["dailyPortion"])
    }
    
    init(name: String, type: String,
         availableWeight: Double,
         nutrition: NutritionFacts, gi: Int = 0,
         dailyPortion: DailyPortion,
         weightMeasure: String = "g") {

        self.name = name
        self.type = type
        
        self.availableWeight = availableWeight
        self.nutrition = nutrition
        self.gi = gi
        
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
