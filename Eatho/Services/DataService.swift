//
//  DataService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 20/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

class DataService {
    static let instance = DataService()
    
    private let foods = [
        FoodItem(name: "Parmesan cheese", icon: "content_item_cheese.png", weight: 60, calories: 431, proteins: 38, carbs: 4.1, fats: 29),
        FoodItem(name: "Grape", icon: "content_item_grape.png", weight: 70, calories: 65, proteins: 0.6, carbs: 16.8, fats: 0.2),
        FoodItem(name: "Avocado", icon: "content_item_avocado.png", weight: 120, calories: 160, proteins: 2, carbs: 22, fats: 76),
        FoodItem(name: "Chicken", icon: "content_item_chiken.png", weight: 100, calories: 170, proteins: 16, carbs: 0, fats: 14)
    ]
    
    func getFoods() -> [FoodItem] {
        return foods
    }
}
