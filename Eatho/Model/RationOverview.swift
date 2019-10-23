//
//  RationOverview.swift
//  Eatho
//
//  Created by Серафима Зыкова on 22/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

struct RationOverview {
    let data: [(String, Double)]
    
    init(nutrition: OverallNutrition) {
        data = [
            ("Sugars".localized, nutrition.sugars),
            ("Fiber".localized, nutrition.fiber),
            ("Trans".localized, nutrition.trans)
        ]
    }
}
