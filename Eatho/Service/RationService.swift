//
//  RetionService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import SwiftyJSON

class RationService {
    static let instance = RationService()
    
    public private(set) var diary = [Ration]()
    public private(set) var presentedRationIndex = -1
    
    var nutrition: Nutrition? {
        get {
            if presentedRationIndex == -1 { return nil }
            return diary[presentedRationIndex].nutrition
        }
    }
    
    var currentRation: [FoodItem]? {
        get {
            if presentedRationIndex == -1 { return nil }
            return diary[presentedRationIndex].ration
        }
    }
    
    func resetData() {
        diary = []
        presentedRationIndex = -1
    }
    
    func removeItem(index: Int, completion: @escaping CompletionHandler) {
        if presentedRationIndex == -1 { return }
        let curRation = diary[presentedRationIndex]
        
        self.updateNutrition(forRation: curRation, nutritionFacts: curRation.ration[index].food!.nutrition, portion: -curRation.ration[index].portion!)
        
        delete(date: curRation.date, completion: completion)
        
        curRation.ration.remove(at: index)
    }
    
    func incPortion(name: String) {
        if presentedRationIndex == -1 { return }
        let curRation = diary[presentedRationIndex]
        
        if let row = curRation.ration.firstIndex(where: { $0.food!.name == name }) {
            let food = curRation.ration[row]
            let delta = food.delta ?? 0
            let available = food.available ?? 0
            let portion = food.portion ?? 0
            
            var deltaWeight = 0.0
            if portion + delta < available {
                deltaWeight = delta
            } else {
                deltaWeight = available - portion
            }
            
            curRation.ration[row].updateWeight(delta: deltaWeight)
            self.updateNutrition(forRation: curRation, nutritionFacts: food.food!.nutrition, portion: deltaWeight)
            NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
            
            update(ration: curRation) { (success, err) in
                //todo
            }
        }
    }
    
    func decPortion(name: String) {
        if presentedRationIndex == -1 { return }
        let curRation = diary[presentedRationIndex]
        
        if let row = curRation.ration.firstIndex(where: { $0.food!.name == name }) {
            let food = curRation.ration[row]
            let delta = food.delta ?? 0
            let portion = food.portion ?? 0
            
            var deltaWeight = 0.0
            if portion - delta >= 0 {
                deltaWeight = -delta
            } else {
                deltaWeight = -portion
            }
            
            curRation.ration[row].updateWeight(delta: deltaWeight)
            self.updateNutrition(forRation: curRation, nutritionFacts: food.food!.nutrition, portion: deltaWeight)
            NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
            
            update(ration: curRation) { (success, err) in
                //todo
            }
        }
    }
    
    func addToRation(food: FoodItem, handler: @escaping CompletionHandler) {
        if presentedRationIndex == -1 { return }
        let curRation = diary[presentedRationIndex]
        curRation.ration.append(food)
        
        NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
        update(ration: curRation) { (success, err) in
            handler(success, err)
        }
    }
    
    func requestRation(handler: @escaping CompletionHandler) {
        get(handler: handler) { (json) in
            guard let dateStr = json["date"].string else { return }
            
            let formatter = ISO8601DateFormatter()
            guard let date = formatter.date(from: dateStr) else { return }
            
            do {
                let ration = try Ration(json: json)
                self.diary.append(ration)
                
                let day = 24.0 * 60 * 60
                let interval = date.timeIntervalSinceNow
                if interval < 0 && day + interval >= 0 {
                    self.presentedRationIndex = self.diary.count - 1
                }
            } catch let err {
                print(err)
            }
        }
    }
    
    func prepRation(forDays days: Int, handler: @escaping CompletionHandler) {
        prepRequest(days: days, handler: handler) { (json) in
            do {
                let ration = try Ration(json: json)
                self.diary.append(ration)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    private func updateNutrition(forRation ration: Ration, nutritionFacts: NutritionFacts, portion: Double) {
        guard let kcal = nutritionFacts.calories.total, let proteins = nutritionFacts.proteins, let carbs = nutritionFacts.carbs.total, let fats = nutritionFacts.fats.total else { return }
        
        let pkcal = kcal * portion / 100, pp = proteins * portion / 100, pc = carbs * portion / 100, pf = fats * portion / 100
        
        ration.nutrition.calories += pkcal
        ration.nutrition.proteins += pp
        ration.nutrition.carbs += pc
        ration.nutrition.fats += pf
    }
}
