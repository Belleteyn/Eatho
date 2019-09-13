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
    
    var isValid: Bool {
        get {
            return abs(100 - proteins["percent"]! - carbs["percent"]! - fats["percent"]!) < 0.2
        }
    }
    
    mutating func setProteins(grams: Double?, percent: Double? = nil, updCalories: Bool = false) {
        if let grams = grams {
            let kcal = grams * 4.1
            
            if updCalories {
                calories += (kcal - proteins["kcal"]!)
            }
            
            let percent = calories > 0 ? kcal * 100 / calories : 0
            proteins = [ "kcal": kcal, "g": grams, "percent": percent ]
        } else if let percent = percent {
            let kcal = calories * percent / 100
            let grams = kcal / 4.1
            proteins = [ "kcal": kcal, "g": grams, "percent": percent ]
        }
    }
    
    mutating func setCarbs(grams: Double?, percent: Double? = nil, updCalories: Bool = false) {
        if let grams = grams {
            let kcal = grams * 4.1
            
            if updCalories {
                calories += (kcal - carbs["kcal"]!)
            }
            
            let percent = calories > 0 ? kcal * 100 / calories : 0
            carbs = [ "kcal": kcal, "g": grams, "percent": percent ]
        } else if let percent = percent {
            let kcal = calories * percent / 100
            let grams = kcal / 4.1
            carbs = [ "kcal": kcal, "g": grams, "percent": percent ]
        }
    }
    
    mutating func setFats(grams: Double?, percent: Double? = nil, updCalories: Bool = false) {
        if let grams = grams {
            let kcal = grams * 9.29
            
            if updCalories {
                calories += (kcal - fats["kcal"]!)
            }
            
            let percent = calories > 0 ? kcal * 100 / calories : 0
            fats = [ "kcal": kcal, "g": grams, "percent": percent ]
        } else if let percent = percent {
            let kcal = calories * percent / 100
            let grams = kcal / 9.29
            fats = [ "kcal": kcal, "g": grams, "percent": percent ]
        }
    }
    
    mutating func setCalories(kcal: Double, updGrams: Bool = false) {
        calories = kcal
        
        if updGrams {
            carbs["kcal"] = carbs["percent"]! * calories / 100
            fats["kcal"] = fats["percent"]! * calories / 100
            proteins["kcal"] = proteins["percent"]! * calories / 100
            
            carbs["g"] = carbs["kcal"]! / 4.1
            fats["g"] = fats["kcal"]! / 9.29
            proteins["g"] = proteins["kcal"]! / 4.1
        } else if (calories > 0) {
            carbs["percent"] = carbs["kcal"]! * 100 / calories
            fats["percent"] = fats["kcal"]! * 100 / calories
            proteins["percent"] = proteins["kcal"]! * 100 / calories
        }
    }
}
