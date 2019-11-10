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
    
    var isSet: Bool {
        get {
            return calories > 0
        }
    }
    
    var isValid: Bool {
        get {
            return abs(100 - proteins["percent"]! - carbs["percent"]! - fats["percent"]!) < 0.2
        }
    }
    
    mutating func setVal(index: Int, grams: Double?, percent: Double? = nil, updCalories: Bool = false) {
        if let grams = grams {
            switch index {
            case 0:
                proteins["g"] = grams
            case 1:
                carbs["g"] = grams
            case 2:
                fats["g"] = grams
            default: ()
            }
            
            let p = proteins["g"] ?? 0.0, c = carbs["g"] ?? 0.0, f = fats["g"] ?? 0.0
            calories = p * 4.1 + c * 4.1 + f * 9.29
            if calories != 0 {
                proteins["percent"] = p * 4.1 * 100 / calories
                carbs["percent"] = c * 4.1 * 100 / calories
                fats["percent"] = f * 9.29 * 100 / calories
            }
            
        } else if let percent = percent {
            switch index {
            case 0:
                proteins["percent"] = percent
                proteins["g"] = percent * calories / 4100
            case 1:
                carbs["percent"] = percent
                carbs["g"] = percent * calories / 4100
            case 2:
                fats["percent"] = percent
                fats["g"] = percent * calories / 9290
            default: ()
            }
        }
    }
    
    mutating func setProteins(grams: Double?, percent: Double? = nil, updCalories: Bool = false) {
        if let grams = grams {
            let kcal = grams * 4.1
            
            if updCalories {
                calories += (kcal - proteins["kcal"]!)
            }
            
            let percent = self.proteins["percent"] ?? (calories > 0 ? kcal * 100 / calories : 0)
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
            
            let percent = self.carbs["percent"] ?? (calories > 0 ? kcal * 100 / calories : 0)
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
            
            let percent = self.fats["percent"] ?? (calories > 0 ? kcal * 100 / calories : 0)
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
