//
//  FoodItem.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

struct FoodItem: Codable {
    private (set) public var name: String
    private (set) public var type: String
    private (set) public var icon: String
    
    private (set) public var weightMeasure: String
    private (set) public var pcfMeasure: String
    
    private (set) public var availableWeight: Double
    private (set) public var calories: Double
    private (set) public var proteins: Double
    private (set) public var carbs: Double
    private (set) public var fats: Double
    private (set) public var gi: Int
    
    public var min: Int 
    private (set) public var max: Int
    private (set) public var preferred: Int
    
    private (set) public var portion: Int
    private (set) public var delta: Int
    
    private (set) public var selectionState: Bool
    
    init(name: String, type: String,
         availableWeight: Double,
         calories: Double, proteins: Double, carbs: Double, fats: Double,
         gi: Int = 0,
         min: Int = 0, max: Int = 0, preferred: Int = 0,
         portion: Int = 0, delta: Int = 0,
         selectionState: Bool = false,
         weightMeasure: String = "g", pcfMeasure: String = "g") {
        self.name = name
        self.type = type
        self.icon = "content_item_\(type).png"
        
        self.availableWeight = availableWeight
        self.calories = calories
        self.proteins = proteins
        self.carbs = carbs
        self.fats = fats
        self.gi = gi
        
        self.weightMeasure = weightMeasure
        self.pcfMeasure = pcfMeasure
        self.selectionState = selectionState
        
        self.min = min
        self.max = max
        self.preferred = preferred
        
        self.portion = portion
        self.delta = delta
    }
    
    mutating func updateWeight(delta: Int) {
        portion += delta
    }
}
