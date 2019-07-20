//
//  FoodItem.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

struct FoodItem {
    private (set) public var name: String
    private (set) public var icon: String
    
    private (set) public var weightMeasure: String
    private (set) public var pcfMeasure: String
    
    private (set) public var weight: Double
    private (set) public var calories: Double
    private (set) public var proteins: Double
    private (set) public var carbs: Double
    private (set) public var fats: Double
    
    private (set) public var selectionState: Bool
    
    init(name: String, icon: String,
         weight: Double, calories: Double,
         proteins: Double, carbs: Double, fats: Double,
         selectionState: Bool = false,
         weightMeasure: String = "g", pcfMeasure: String = "g") {
        self.name = name
        self.icon = icon
        self.weight = weight
        self.calories = calories
        self.proteins = proteins
        self.carbs = carbs
        self.fats = fats
        self.weightMeasure = weightMeasure
        self.pcfMeasure = pcfMeasure
        self.selectionState = selectionState
    }
}
