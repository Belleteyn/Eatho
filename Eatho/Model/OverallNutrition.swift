//
//  Nutrition.swift
//  Eatho
//
//  Created by Серафима Зыкова on 15/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

struct OverallNutrition {
    var calories = 0.0
    var proteins = 0.0
    var carbs = 0.0
    var fats = 0.0
    
    var sugars = 0.0
    var fiber = 0.0
    var trans = 0.0
    
    init(calories kcal: Double, proteins p: Double, carbs c: Double, fats f: Double, sugars: Double = 0, fiber: Double = 0, trans: Double = 0) {
        self.calories = kcal
        self.proteins = p
        self.carbs = c
        self.fats = f
        
        self.sugars = sugars
        self.fiber = fiber
        self.trans = trans
    }
    
    init(_ n: NutritionFacts) throws {
        guard let kcal = n.calories.total, let p = n.proteins, let c = n.carbs.total, let f = n.fats.total else { throw DataParseError.corruptedData }
        
        self.calories = kcal
        self.proteins = p
        self.carbs = c
        self.fats = f
        
        if let sugars = n.carbs.sugars {
            self.sugars = sugars
        }
        if let fiber = n.carbs.dietaryFiber {
            self.fiber = fiber
        }
        if let trans = n.fats.trans {
            self.trans = trans
        }
    }
    
    mutating func addPortion(food: FoodItem) {
        guard let portion = food.portion else { return }
        guard let food = food.food else { return }
        guard let kcal = food.nutrition.calories.total, let p = food.nutrition.proteins, let c = food.nutrition.carbs.total, let f = food.nutrition.fats.total else { return }
        
        calories += portioned(kcal, portion: portion)
        proteins += portioned(p, portion: portion)
        carbs += portioned(c, portion: portion)
        fats += portioned(f, portion: portion)
        
        if let sugars = food.nutrition.carbs.sugars {
            self.sugars += portioned(sugars, portion: portion)
        }
        if let fiber = food.nutrition.carbs.dietaryFiber {
            self.fiber += portioned(fiber, portion: portion)
        }
        if let trans = food.nutrition.fats.trans {
            self.trans += portioned(trans, portion: portion)
        }
    }
    
    mutating func reset() {
        calories = 0
        proteins = 0
        carbs = 0
        fats = 0
        sugars = 0
        fiber = 0
        trans = 0
    }
    
    mutating func set(nutrition: NutritionFacts) {
        guard let kcal = nutrition.calories.total, let p = nutrition.proteins, let c = nutrition.carbs.total, let f = nutrition.fats.total else { return }
        
        calories = kcal
        proteins = p
        carbs = c
        fats = f
        
        if let sugars = nutrition.carbs.sugars {
            self.sugars = sugars
        }
        if let fiber = nutrition.carbs.dietaryFiber {
            self.fiber = fiber
        }
        if let trans = nutrition.fats.trans {
            self.trans = trans
        }
    }
    
    private func portioned(_ val: Double, portion: Double) -> Double {
        return val * portion / 100
    }
}
