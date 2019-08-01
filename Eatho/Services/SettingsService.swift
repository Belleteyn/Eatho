//
//  SettingsService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

class SettingsService {
    static let instance = SettingsService()
    
    let defaults = UserDefaults.standard
    
    var isConfigured: Bool {
        get {
            return defaults.bool(forKey: IS_CONFIGURED)
        }
        
        set {
            defaults.set(newValue, forKey: IS_CONFIGURED)
        }
    }
    
    func leanMass(weightKg w: Double, heightM h: Double, age: Double, gender: Int) -> Double {
        let bmi = w / (h * h)
        let fatPercent = gender == 1 ? (1.51 * bmi - 0.7 * age - 3.6 + 1.4) : (1.51 * bmi - 0.7 * age + 1.4)
        return (w * (100 - fatPercent) / 100)
    }
    
    func calculateNutrients(weightKg w: Double, heightM h: Double, age: Double, gender: Int, activityIndex: Int, shortage: Double, p: inout Double, c: inout Double, f: inout Double, calories: inout Double) {

        let lean = SettingsService.instance.leanMass(weightKg: w, heightM: h, age: age, gender: gender)
        
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
        
        let nShortage = shortage / 2
        f = 1.1 * lean - nShortage / 9.29
        c = 4 * lean - nShortage / 4.1
        
        calories = p * 4.1 + c * 4.1 + f * 9.29
    }
}
