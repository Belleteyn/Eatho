//
//  Nutrient.swift
//  Eatho
//
//  Created by Серафима Зыкова on 15/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

enum NutrientCellType {
    case main, enclosed
}

struct Nutrient {
    var name = ""
    var perPorition = 0.0
    var per100g = 0.0
    var type = NutrientCellType.main
}
