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
    var available: Double?
    var delta: Double?
    var portion: Double?
    var dailyPortion: DailyPortion
    
    init(json: JSON) {
        let food = json["food"]
        self.food = Food(json: food)
        self.available = json["available"].double
        self.delta = json["delta"].double
        self.portion = json["portion"].double
        
        self.dailyPortion = DailyPortion(json: json["dailyPortion"])
    }
    
    init(name: String, type: String,
         availableWeight: Double,
         nutrition: NutritionFacts,
         dailyPortion: DailyPortion) {

        self.food = Food(name: name, type: type, nutrition: nutrition)
        self.available = availableWeight
        self.dailyPortion = dailyPortion
    }
    
    func toJson() -> JSON? {
        do {
            guard let food = self.food, let name = food.name else { return nil }
            
            let data = try JSONEncoder().encode(self)
            var json = try JSON(data: data)
            
            //TODO: name localization
            json["food"]["name"] = ["en": name]
            return json
        } catch let err {
            print(err)
            return nil
        }
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
    var min: Double?
    var max: Double?
    
    init(json: JSON) {
        self.min = json["min"].double
        self.max = json["max"].double
    }
    
    init(min: Double, max: Double) {
        self.min = min
        self.max = max
    }
}
