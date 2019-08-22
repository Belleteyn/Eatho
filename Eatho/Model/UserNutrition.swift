//
//  UserNutrition.swift
//  Eatho
//
//  Created by Серафима Зыкова on 22/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

struct UserNutrition: Codable {
    var calories = 0.0
    var proteins = [
        "kcal": 0.0,
        "g": 0.0,
        "percent": 0
    ]
    var carbs = [
        "kcal": 0.0,
        "g": 0.0,
        "percent": 0
    ]
    var fats = [
        "kcal": 0.0,
        "g": 0.0,
        "percent": 0
    ]
    
    mutating func setProteins(grams: Double?, percent: Double? = nil) {
        if let grams = grams {
            let kcal = grams * 4.1
            let percent = calories > 0 ? round(kcal * 1000 / calories) / 10 : 0
            proteins = [ "kcal": kcal, "g": grams, "percent": percent ]
        } else if let percent = percent {
            let kcal = calories * percent / 100
            let grams = kcal / 4.1
            proteins = [ "kcal": kcal, "g": grams, "percent": percent ]
        }
    }
    
    mutating func setCarbs(grams: Double?, percent: Double? = nil) {
        if let grams = grams {
            let kcal = grams * 4.1
            let percent = calories > 0 ? round(kcal * 1000 / calories) / 10 : 0
            carbs = [ "kcal": kcal, "g": grams, "percent": percent ]
        } else if let percent = percent {
            let kcal = calories * percent / 100
            let grams = kcal / 4.1
            carbs = [ "kcal": kcal, "g": grams, "percent": percent ]
        }
    }
    
    mutating func setFats(grams: Double?, percent: Double? = nil) {
        if let grams = grams {
            let kcal = grams * 9.29
            let percent = calories > 0 ? round(kcal * 1000 / calories) / 10 : 0
            fats = [ "kcal": kcal, "g": grams, "percent": percent ]
        } else if let percent = percent {
            let kcal = calories * percent / 100
            let grams = kcal / 9.29
            fats = [ "kcal": kcal, "g": grams, "percent": percent ]
        }
    }
    
    mutating func setCalories(kcal: Double) {
        calories = kcal
        if (calories > 0) {
            carbs["percent"] = carbs["kcal"]! * 100 / calories
            fats["percent"] = fats["kcal"]! * 100 / calories
            proteins["percent"] = proteins["kcal"]! * 100 / calories
        }
    }
}
