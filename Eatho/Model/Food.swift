//
//  Food.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Food: Codable {
    private (set) public var _id: String?
    private (set) public var name: String?
    private (set) public var type: String?
    
    private (set) public var nutrition: NutritionFacts
    private (set) public var gi: Int?
    
    var icon: String {
        guard let type = self.type else { return "" }
        return "content_item_\(type).png"
    }
    
    init(json: JSON) {
        self._id = json["_id"].string
        self.name = json["name"]["en"].string
        self.type = json["type"].string
        self.gi = json["gi"].int
        
        self.nutrition = NutritionFacts(json: json["nutrition"])
    }
    
    init(name: String, type: String, nutrition: NutritionFacts, gi: Int = 0) {
        self.name = name
        self.type = type
        self.nutrition = nutrition
        self.gi = gi
    }
}
