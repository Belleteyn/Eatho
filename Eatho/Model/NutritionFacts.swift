//
//  NutritionFacts.swift
//  Eatho
//
//  Created by Серафима Зыкова on 01/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import SwiftyJSON

struct NutritionFacts: Codable {
    var calories: Calories
    var proteins: Double?
    var carbs: Carbs
    var fats: Fats
    var micronutrients: Micronutrients?
    
    var pKcal: Double {
        return (proteins ?? 0.0) * 4.1
    }
    var pPercent: Double {
        if calories.total != nil {
            return pKcal * 100 / calories.total!
        } else {
            return 0
        }
    }
    
    var cKcal: Double {
        return (carbs.total ?? 0.0) * 4.1
    }
    var cPercent: Double {
        if calories.total != nil {
            return cKcal * 100 / calories.total!
        } else {
            return 0
        }
    }
    
    var fKcal: Double {
        return (fats.total ?? 0.0) * 9.29
    }
    var fPercent: Double {
        if calories.total != nil {
            return fKcal * 100 / calories.total!
        } else {
            return 0
        }
    }
    
    init(json: JSON) {
        calories = Calories(json: json["calories"])
        proteins = json["proteins"].double
        carbs = Carbs(json: json["carbs"])
        fats = Fats(json: json["fats"])
        micronutrients = Micronutrients(json: json["micronutrients"])
    }
    
    init(calories: Double, proteins: Double, carbs: Double, fats: Double) {
        self.calories = Calories(calories: calories)
        self.proteins = proteins
        self.carbs = Carbs(carbs: carbs)
        self.fats = Fats(fats: fats)
    }
    
    
    func getMacro(portion: Double) -> [Nutrient] {
        var macro = [Nutrient]()
        macro.append(Nutrient(name: "Calories", perPorition: calories.total! * portion / 100, per100g: calories.total!, type: .main))
        
        if calories.fromFat != nil {
            macro.append(Nutrient(name: "from fat", perPorition: calories.fromFat! * portion / 100, per100g: calories.fromFat!, type: .enclosed))
        }
        
        macro.append(Nutrient(name: "Proteins", perPorition: proteins! * portion / 100, per100g: proteins!, type: .main))
        
        macro.append(Nutrient(name: "Carbs", perPorition: carbs.total! * portion / 100, per100g: carbs.total!, type: .main))
        if carbs.dietaryFiber != nil {
            macro.append(Nutrient(name: "dietary fiber", perPorition: carbs.dietaryFiber! * portion / 100, per100g: carbs.dietaryFiber!, type: .enclosed))
        }
        if carbs.sugars != nil {
            macro.append(Nutrient(name: "sugars", perPorition: carbs.sugars! * portion / 100, per100g: carbs.sugars!, type: .enclosed))
        }
        
        macro.append(Nutrient(name: "Fats", perPorition: fats.total! * portion / 100, per100g: fats.total!, type: .main))
        if fats.trans != nil {
            macro.append(Nutrient(name: "trans", perPorition: fats.trans! * portion / 100, per100g: fats.trans!, type: .enclosed))
        }
        if fats.saturated != nil {
            macro.append(Nutrient(name: "saturated", perPorition: fats.saturated! * portion / 100, per100g: fats.saturated!, type: .enclosed))
        }
        if fats.monounsaturated != nil {
            macro.append(Nutrient(name: "monounsaturated", perPorition: fats.monounsaturated! * portion / 100, per100g: fats.monounsaturated!, type: .enclosed))
        }
        if fats.polyunsaturated != nil {
            macro.append(Nutrient(name: "polyunsaturated", perPorition: fats.polyunsaturated! * portion / 100, per100g: fats.polyunsaturated!, type: .enclosed))
        }
        
        return macro
    }
}

struct Calories: Codable {
    var total: Double?
    var fromFat: Double?
    
    init(json: JSON) {
        self.total = json["total"].double
        self.fromFat = json["fromFat"].double
    }
    
    init(calories: Double) {
        self.total = calories
    }
}

struct Carbs: Codable {
    var total: Double?
    var dietaryFiber: Double?
    var sugars: Double?
    
    init(json: JSON) {
        self.total = json["total"].double
        self.dietaryFiber = json["dietaryFiber"].double
        self.sugars = json["sugars"].double
    }
    
    init(carbs: Double) {
        self.total = carbs
    }
}

struct Fats: Codable {
    var total: Double?
    var trans: Double?
    var saturated: Double?
    var polyunsaturated: Double?
    var monounsaturated: Double?
    
    init(json: JSON) {
        self.total = json["total"].double
        self.trans = json["trans"].double
        self.saturated = json["saturated"].double
        self.polyunsaturated = json["polyunsaturated"].double
        self.monounsaturated = json["monounsaturated"].double
    }
    
    init(fats: Double) {
        self.total = fats
    }
}

struct Micronutrients: Codable {
    var calcium: Double?
    var iron: Double?
    var magnesium: Double?
    var phosphorous: Double?
    var potassium: Double?
    var sodium: Double?
    var zinc: Double?
    var thiamin: Double?
    var riboflavin: Double?
    var niacin: Double?
    var cholesterol: Double?
    var caffeinne: Double?
    var vitamins: Vitamins?
    
    init(json: JSON) {
        self.calcium = json["calcium"].double
        self.iron = json["iron"].double
        self.magnesium = json["magnesium"].double
        self.phosphorous = json["phosphorous"].double
        self.potassium = json["potassium"].double
        self.sodium = json["sodium"].double
        self.zinc = json["zinc"].double
        self.riboflavin = json["riboflavin"].double
        self.niacin = json["niacin"].double
        self.cholesterol = json["cholesterol"].double
        self.caffeinne = json["caffeinne"].double
        self.vitamins = Vitamins(json: json["vitamins"])
    }
}

struct Vitamins: Codable {
    var c: Double?
    var b6: Double?
    var folate: Double?
    var b12: Double?
    var arae: Double?
    var aiu: Double?
    var e: Double?
    var d2d3: Double?
    var d: Double?
    var k: Double?
    
    init(json: JSON) {
        self.c = json["c"].double
        self.b6 = json["b6"].double
        self.folate = json["folate"].double
        self.b12 = json["b12"].double
        self.arae = json["arae"].double
        self.aiu = json["aiu"].double
        self.e = json["e"].double
        self.d2d3 = json["d2d3"].double
        self.d = json["d"].double
        self.k = json["k"].double
    }
}
