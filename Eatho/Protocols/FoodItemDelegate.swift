//
//  FoodItemDelegate.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

protocol FoodItemDelegate {
    func foodItemChanged(food: FoodItem, updatedIndex: Int?)
}
