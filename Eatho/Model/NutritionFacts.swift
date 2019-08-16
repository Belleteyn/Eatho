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
    var gi: Double?
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
        gi = json["glycemicIndex"].double
        micronutrients = Micronutrients(json: json)
    }
    
    init(calories: Double, proteins: Double, carbs: Double, fats: Double) {
        self.calories = Calories(calories: calories)
        self.proteins = proteins
        self.carbs = Carbs(carbs: carbs)
        self.fats = Fats(fats: fats)
    }
    
    
    func getMacro(portion p: Double?) -> [Nutrient] {
        var macro = [Nutrient]()
        macro.append(Nutrient(name: "Calories", perPorition: p != nil ? calories.total! * p! / 100 : nil, per100g: calories.total!, measure: "g", type: .main))
        
        if calories.fromFat != nil {
            macro.append(Nutrient(name: "from fat", perPorition: p != nil ? calories.fromFat! * p! / 100 : nil, per100g: calories.fromFat!, measure: "g", type: .enclosed))
        }
        
        macro.append(Nutrient(name: "Proteins", perPorition: p != nil ? proteins! * p! / 100 : nil, per100g: proteins!, measure: "g", type: .main))
        
        macro.append(Nutrient(name: "Carbs", perPorition: p != nil ? carbs.total! * p! / 100 : nil, per100g: carbs.total!, measure: "g", type: .main))
        if carbs.dietaryFiber != nil {
            macro.append(Nutrient(name: "dietary fiber", perPorition: p != nil ? carbs.dietaryFiber! * p! / 100 : nil, per100g: carbs.dietaryFiber!, measure: "g", type: .enclosed))
        }
        if carbs.sugars != nil {
            macro.append(Nutrient(name: "sugars", perPorition: p != nil ? carbs.sugars! * p! / 100 : nil, per100g: carbs.sugars!, measure: "g", type: .enclosed))
        }
        
        macro.append(Nutrient(name: "Fats", perPorition: p != nil ? fats.total! * p! / 100 : nil, per100g: fats.total!, measure: "g", type: .main))
        if fats.trans != nil {
            macro.append(Nutrient(name: "trans", perPorition: p != nil ? fats.trans! * p! / 100 : nil, per100g: fats.trans!, measure: "g", type: .enclosed))
        }
        if fats.saturated != nil {
            macro.append(Nutrient(name: "saturated", perPorition: p != nil ? fats.saturated! * p! / 100 : nil, per100g: fats.saturated!, measure: "g", type: .enclosed))
        }
        if fats.monounsaturated != nil {
            macro.append(Nutrient(name: "monounsaturated", perPorition: p != nil ? fats.monounsaturated! * p! / 100 : nil, per100g: fats.monounsaturated!, measure: "g", type: .enclosed))
        }
        if fats.polyunsaturated != nil {
            macro.append(Nutrient(name: "polyunsaturated", perPorition: p != nil ? fats.polyunsaturated! * p! / 100 : nil, per100g: fats.polyunsaturated!, measure: "g", type: .enclosed))
        }
        
        if gi != nil {
            macro.append(Nutrient(name: "Glycemic index", perPorition: nil, per100g: gi!, measure: "", type: .main))
        }
        
        return macro
    }
    
    func getMinerals(portion p: Double?) -> [Nutrient] {
        var micro = [Nutrient]()
        guard let nutrients = self.micronutrients else { return micro }
        
        if nutrients.caffeinne != nil {
            micro.append(Nutrient(name: "Caffeinne", perPorition: p != nil ? nutrients.caffeinne! * p! / 100 : nil, per100g: nutrients.caffeinne!, measure: "mg", type: .main))
        }
        if nutrients.calcium != nil {
            micro.append(Nutrient(name: "Calcium", perPorition: p != nil ? nutrients.calcium! * p! / 100 : nil, per100g: nutrients.calcium!, measure: "mg", type: .main))
        }
        if nutrients.cholesterol != nil {
            micro.append(Nutrient(name: "Cholesterol", perPorition: p != nil ? nutrients.cholesterol! * p! / 100 : nil, per100g: nutrients.cholesterol!, measure: "mg", type: .main))
        }
        if nutrients.iron != nil {
            micro.append(Nutrient(name: "Iron", perPorition: p != nil ? nutrients.iron! * p! / 100 : nil, per100g: nutrients.iron!, measure: "mg", type: .main))
        }
        if nutrients.magnesium != nil {
            micro.append(Nutrient(name: "Magnesium", perPorition: p != nil ? nutrients.magnesium! * p! / 100 : nil, per100g: nutrients.magnesium!, measure: "mg", type: .main))
        }
        if nutrients.niacin != nil {
            micro.append(Nutrient(name: "Niacin", perPorition: p != nil ? nutrients.niacin! * p! / 100 : nil, per100g: nutrients.niacin!, measure: "mg", type: .main))
        }
        if nutrients.phosphorous != nil {
            micro.append(Nutrient(name: "Phosphorous", perPorition: p != nil ? nutrients.phosphorous! * p! / 100 : nil, per100g: nutrients.phosphorous!, measure: "mg", type: .main))
        }
        if nutrients.potassium != nil {
            micro.append(Nutrient(name: "Potassium", perPorition: p != nil ? nutrients.potassium! * p! / 100 : nil, per100g: nutrients.potassium!, measure: "mg", type: .main))
        }
        if nutrients.riboflavin != nil {
            micro.append(Nutrient(name: "Riboflavin", perPorition: p != nil ? nutrients.riboflavin! * p! / 100 : nil, per100g: nutrients.riboflavin!, measure: "mg", type: .main))
        }
        if nutrients.sodium != nil {
            micro.append(Nutrient(name: "Sodium", perPorition: p != nil ? nutrients.sodium! * p! / 100 : nil, per100g: nutrients.sodium!, measure: "mg", type: .main))
        }
        if nutrients.thiamin != nil {
            micro.append(Nutrient(name: "Thiamin", perPorition: p != nil ? nutrients.thiamin! * p! / 100 : nil, per100g: nutrients.thiamin!, measure: "mg", type: .main))
        }
        if nutrients.zinc != nil {
            micro.append(Nutrient(name: "Zinc", perPorition: p != nil ? nutrients.zinc! * p! / 100 : nil, per100g: nutrients.zinc!, measure: "mg", type: .main))
        }
        
        return micro
    }
    
    func getVitamins(portion p: Double?) -> [Nutrient] {
        var vitamins = [Nutrient]()
        guard let nutrients = self.micronutrients else { return vitamins }
        guard let v = nutrients.vitamins else { return vitamins }
        
        if v.arae != nil {
            vitamins.append(Nutrient(name: "Vitamin A", perPorition: p != nil ? v.arae! * p! / 100 : nil, per100g: v.arae!, measure: "mg", type: .main))
        }
        if v.b6 != nil {
            vitamins.append(Nutrient(name: "B6", perPorition: p != nil ? v.b6! * p! / 100 : nil, per100g: v.b6!, measure: "mg", type: .main))
        }
        if v.b12 != nil {
            vitamins.append(Nutrient(name: "B12", perPorition: p != nil ? v.b12! * p! / 100 : nil, per100g: v.b12!, measure: "mg", type: .main))
        }
        if v.c != nil {
            vitamins.append(Nutrient(name: "Vitamin C", perPorition: p != nil ? v.c! * p! / 100 : nil, per100g: v.c!, measure: "mg", type: .main))
        }
        if v.d != nil {
            vitamins.append(Nutrient(name: "Vitamin D", perPorition: p != nil ? v.d! * p! / 100 : nil, per100g: v.d!, measure: "mg", type: .main))
        }
        if v.e != nil {
            vitamins.append(Nutrient(name: "Vitamin E", perPorition: p != nil ? v.e! * p! / 100 : nil, per100g: v.e!, measure: "mg", type: .main))
        }
        if v.k != nil {
            vitamins.append(Nutrient(name: "Vitamin K", perPorition: p != nil ? v.k! * p! / 100 : nil, per100g: v.k!, measure: "mg", type: .main))
        }
        if v.folate != nil {
            vitamins.append(Nutrient(name: "Folate", perPorition: p != nil ? v.folate! * p! / 100 : nil, per100g: v.folate!, measure: "mg", type: .main))
        }
        
        return vitamins
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
