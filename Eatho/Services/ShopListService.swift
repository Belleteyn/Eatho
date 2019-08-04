//
//  ShopListService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 04/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

class ShopListService {
    static let instance = ShopListService()
    
    private (set) public var list = [
        "Milk": false,
        "Salmon": false,
        "Banana": true,
        "Avocado": true
    ]
    
    private (set) public var mostRecentList = [
        "Kefir",
        "Cheese",
        "Wholegrain rue bread"
    ]
}
