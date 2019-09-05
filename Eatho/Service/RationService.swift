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
    public private(set) var nutrition = Nutrition(calories: 0, proteins: 0, carbs: 0, fats: 0)
    public private(set) var currentRation: [FoodItem] = []
    public private(set) var currentRationIndex = -1
    
    func resetData() {
        diary = []
        nutrition = Nutrition(calories: 0, proteins: 0, carbs: 0, fats: 0)
        currentRation = []
        currentRationIndex = -1
    }
    
    func removeItem(index: Int) {
        updateNutrition(delta: currentRation[index].food!.nutrition, portion: currentRation[index].portion!, inc: false)
        currentRation.remove(at: index)
        
        NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
    }
    
    private func updateNutrition(delta: NutritionFacts, portion: Double, inc: Bool) {
        let kcal = delta.calories.total! * portion / 100, c = delta.carbs.total! * portion / 100, f = delta.fats.total! * portion / 100, p = delta.proteins! * portion / 100
        
        nutrition.calories += inc ? kcal : -kcal
        nutrition.carbs += inc ? c : -c
        nutrition.fats += inc ? f : -f
        nutrition.proteins += inc ? p : -p
    }
    
    func incPortion(name: String) {
        if let row = self.currentRation.firstIndex(where: { $0.food!.name == name }) {
            //todo: upd ration in diary, not only currentRation
            update(ration: diary[presentedRationIndex]) { (success, err) in
                if success {
                    let food = self.currentRation[row]
                    let delta = food.delta ?? 0
                    let available = food.available ?? 0
                    let portion = food.portion ?? 0
                    
                    self.updateNutrition(delta: food.food!.nutrition, portion: food.portion!, inc: false)
                    if portion + delta < (available) {
                        self.currentRation[row].updateWeight(delta: delta)
                    } else {
                        self.currentRation[row].updateWeight(delta: (available - portion))
                    }
                    self.updateNutrition(delta: self.currentRation[row].food!.nutrition, portion: self.currentRation[row].portion!, inc: true)
                    
                    NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
                }
            }
        }
    }
    
    func decPortion(name: String) {
        if let row = self.currentRation.firstIndex(where: { $0.food!.name == name }) {
            //todo: upd ration in diary, not only currentRation
            update(ration: diary[presentedRationIndex]) { (success, err) in
                if success {
                    let food = self.currentRation[row]
                    let delta = food.delta ?? 0
                    let portion = food.portion ?? 0
                    
                    self.updateNutrition(delta: self.currentRation[row].food!.nutrition, portion: self.currentRation[row].portion!, inc: false)
                    if portion - delta >= 0 {
                        self.currentRation[row].updateWeight(delta: -delta)
                    } else {
                        self.currentRation[row].updateWeight(delta: -portion)
                    }
                    self.updateNutrition(delta: self.currentRation[row].food!.nutrition, portion: self.currentRation[row].portion!, inc: true)
                    
                    NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
                }
            }
        }
    }
    
    func addToRation(food: FoodItem, handler: @escaping CompletionHandler) {
        //todo: upd ration in diary, not only currentRation
        update(ration: diary[presentedRationIndex]) { (success, err) in
            if success {
                self.currentRation.append(food)
            }
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
                    self.currentRation = ration.ration
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
}
