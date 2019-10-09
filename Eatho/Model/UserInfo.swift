//
//  UserInfo.swift
//  Eatho
//
//  Created by Серафима Зыкова on 01/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    var setupNutrientsFlag = true
    var gender = 0
    var weight = 0.0
    var height = 0.0 //cm
    var age = 0 //years
    var caloriesShortage = 0.0
    var activityIndex = 0
    var nutrition = UserNutrition()
    var isShoppingListAutomated = true
    var lbsMetrics = false
    var localeLanguage: String?
    
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
        
        NotificationCenter.default.post(name: NOTIF_USER_NUTRITION_CHANGED, object: nil)
    }
    
    private func leanMass(weightKg w: Double, heightM h: Double, age: Double, gender: Int) -> Double {
        let bmi = w / (h * h)
        let fatPercent = gender == 1
            ? (1.51 * bmi - 0.7 * age - 2.2) //male
            : (1.51 * bmi - 0.7 * age + 1.4) //female
        return (w * (100 - fatPercent) / 100)
    }
}
