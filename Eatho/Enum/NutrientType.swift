//
//  NutrientType.swift
//  Eatho
//
//  Created by Серафима Зыкова on 14/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import UIKit

struct NutrientData {
    let name: String
    let measure: String
    let color: UIColor
    
    var value: Double = 0
    var expectedValue: Double = 0
}

enum NutrientType {
    case Calories, Proteins, Carbs, Fats
}
