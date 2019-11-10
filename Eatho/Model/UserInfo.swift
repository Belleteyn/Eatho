//
//  UserInfo.swift
//  Eatho
//
//  Created by Серафима Зыкова on 01/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserInfo: Codable {
    var setupNutrientsFlag: Bool
    var gender: Int
    var weight: Double
    var height: Double //cm
    var age: Int //years
    var caloriesShortage: Double
    var activityIndex: Int
    var nutrition = UserNutrition()
    var isShoppingListAutomated: Bool
    var imperialMetrics: Bool
    var localeLanguage: String?
    var localeGMTSeconds: Int?
    
    init() {
        setupNutrientsFlag = false
        gender = 0
        weight = 0.0
        height = 0.0
        age = 0
        caloriesShortage = 0.0
        activityIndex = 0
        isShoppingListAutomated = false
        imperialMetrics = false
        
        localeLanguage = Locale.current.languageCode
        localeGMTSeconds = TimeZone.current.secondsFromGMT()
    }
    
    init(json: JSON) {
        setupNutrientsFlag = json["setupNutrientsFlag"].bool ?? false
        gender = json["gender"].int ?? 0
        weight = json["weight"].double ?? 0.0
        height = json["height"].double ?? 0.0
        age = json["age"].int ?? 0
        caloriesShortage = json["caloriesShortage"].double ?? 0.0
        activityIndex = json["activityIndex"].int ?? 0
        nutrition = UserNutrition(json: json["nutrition"])
        isShoppingListAutomated = json["isShoppingListAutomated"].bool ?? false
        imperialMetrics = json["imperialMetrics"].bool ?? false
        
        localeLanguage = json["localeLanguage"].string ?? Locale.current.languageCode
        localeGMTSeconds = json["localeGMTSeconds"].int ?? TimeZone.current.secondsFromGMT()
    }
    
    mutating func recalculateNutrition() {
        let lean = leanMass(weightKg: weight, heightM: height, age: Double(age), gender: gender)
        
        var p, c, f, calories: Double
        switch activityIndex {
        case 1:
            p = 1.6 * lean
        case 2:
            p = 1.75 * lean
        case 3:
            p = 2 * lean
        case 4:
            p = 2.5 * lean
        default:
            p = 1.5 * lean
        }
        
        let nShortage = caloriesShortage / 2
        f = 1.1 * lean - nShortage / 9.29
        c = 4 * lean - nShortage / 4.1
        
        calories = p * 4.1 + c * 4.1 + f * 9.29
        
        nutrition.setCalories(kcal: round(calories * 10) / 10)
        nutrition.setFats(grams: round(f * 10) / 10)
        nutrition.setCarbs(grams: round(c * 10) / 10)
        nutrition.setProteins(grams: round(p * 10) / 10)
    }
    
    private func leanMass(weightKg w: Double, heightM h: Double, age: Double, gender: Int) -> Double {
        let bmi = w / (h * h)
        let fatPercent = gender == 1
            ? (1.51 * bmi - 0.7 * age - 2.2) //male
            : (1.51 * bmi - 0.7 * age + 1.4) //female
        return (w * (100 - fatPercent) / 100)
    }
}
