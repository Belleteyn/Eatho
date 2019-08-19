//
//  Nutrition.swift
//  Eatho
//
//  Created by Серафима Зыкова on 15/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

struct Nutrition {
    var calories = 0.0
    var proteins = 0.0
    var carbs = 0.0
    var fats = 0.0
    
    mutating func addPortion(food: FoodItem) {
        guard let portion = food.portion else { return }
        guard let food = food.food else { return }
        
        calories += food.nutrition.calories.total! * portion / 100
        proteins += food.nutrition.proteins! * portion / 100
        carbs += food.nutrition.carbs.total! * portion / 100
        fats += food.nutrition.fats.total! * portion / 100
    }
    
    mutating func reset() {
        calories = 0
        proteins = 0
        carbs = 0
        fats = 0
    }
    
    mutating func set(nutrition: NutritionFacts) {
        calories = nutrition.calories.total!
        proteins = nutrition.proteins!
        carbs = nutrition.carbs.total!
        fats = nutrition.fats.total!
    }
}
