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
    let activityPickerData = [
        "Minimal",
        "Light (training 3 times a week)",
        "Medium (intensive training 3 or more times a week)",
        "High (intensive training everyday)",
        "Extra (athletes)"
    ]
    
    var isConfigured: Bool {
        get {
            return defaults.bool(forKey: IS_CONFIGURED)
        }
        
        set {
            defaults.set(newValue, forKey: IS_CONFIGURED)
        }
    }
    
    var userInfo: UserInfo {
        get {
            if let data = defaults.value(forKey: USER_INFO) as? Data {
                do {
                    let info = try JSONDecoder().decode(UserInfo.self, from: data)
                    return info
                } catch let err {
                    debugPrint("reading UserInfo error: \(err)")
                }
            }
            
            return UserInfo(setupNutrientsFlag: true, gender: 0, weight: 0, height: 0, age: 0, caloriesShortage: 0, activityIndex: 0, nutrition: NutritionFacts(calories: 0, proteins: 0, carbs: 0, fats: 0))
        }
        
        set {
            do {
                let encodedData = try JSONEncoder().encode(newValue)
                defaults.setValue(encodedData, forKey: USER_INFO)
                isConfigured = true
            } catch let err {
                debugPrint("writing UserInfo error: \(err)")
            }
        }
    }
}
