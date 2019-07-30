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
}
