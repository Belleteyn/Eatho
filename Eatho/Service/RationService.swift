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
    private var todayRationIndex = -1
    
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
    
    var currentDate: String? {
        get {
            if presentedRationIndex == -1 { return nil }
            return diary[presentedRationIndex].localizedDateStr
        }
    }

    func isCurrentRationEditable() -> Bool {
        return presentedRationIndex <= todayRationIndex
    }
    
    init() {
        self.subscribeLoggedOut(selector: #selector(loggedOutHandler))
    }
    
    func setCurrent(forISODate date: String?) {
        if let date = date {
            presentedRationIndex = diary.firstIndex(where: { (ration) -> Bool in
                return ration.isoDate == date
            }) ?? -1
        } else {
            presentedRationIndex = todayRationIndex
        }
    }
    
    func isFoodContainedInCurrentRation(id: String) -> Bool {
        guard presentedRationIndex != -1 else { return false }
        
        let res = diary[presentedRationIndex].ration.filter { (food) -> Bool in
            return food.food?._id == id
        }
        return res.count > 0
    }
    
    /**
     remove item by `index` from current ration
     
     possible errors:
     - server error
     - LocalDataError: no ration selected
     */
    func removeItem(index: Int, completion: @escaping RequestCompletion) {
        guard presentedRationIndex != -1 else {
            completion(nil, ResponseError(code: -1, message: ERROR_RATION_INVALID_INDEX))
            return
        }
        
        let curRation = diary[presentedRationIndex]
        
        self.updateNutrition(forRation: curRation, nutritionFacts: curRation.ration[index].food!.nutrition, portion: -curRation.ration[index].portion!)
        
        curRation.ration.remove(at: index)
        update(ration: curRation, completion: completion)
    }
    
    /**
     remove item by `id` from current ration
     
     possible errors:
     - server error
     - LocalDataError: no ration selected, id not found
     */
    func removeItem(id: String, completion: @escaping RequestCompletion) {
        guard presentedRationIndex != -1 else {
            completion(nil, ResponseError(code: -1, message: ERROR_RATION_INVALID_INDEX))
            return
        }
        
        guard let index = (diary[presentedRationIndex].ration.firstIndex { (food) -> Bool in
            food.food?._id == id
        }) else {
            completion(nil, ResponseError(code: -1, message: ERROR_RATION_INVALID_INDEX))
            return
        }
        
        removeItem(index: index, completion: completion)
        NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
    }
    
    /**
     increase portion by `delta` for food with `id` in current ration. Maximum possible value depends on `available` amount of selected food
     
     possible errors:
     - server error
     - LocalDataError: no ration selected, id not found
     */
    func incPortion(id: String, completion: @escaping RequestCompletion) {
        changePortion(id: id, completion: completion) { (portion: Double, delta: Double, available: Double) -> Double in
            var deltaWeight = 0.0
            if portion + delta <= available {
                deltaWeight = delta
            } else {
                deltaWeight = available - portion
            }
            return deltaWeight
        }
    }
    
    /**
     decrease portion by `delta` for food with `id` in current ration. Minimum possible value is 0.
     
     possible errors:
     - server error
     - LocalDataError: no ration selected, id not found
     */
    func decPortion(id: String, completion: @escaping RequestCompletion) {
        changePortion(id: id, completion: completion) { (portion: Double, delta: Double, available: Double) -> Double in
            var deltaWeight = 0.0
            if portion - delta >= 0 {
                deltaWeight = -delta
            } else {
                deltaWeight = -portion
            }
            return deltaWeight
        }
    }
    
    /**
     add `food` to current ration
     
     possible errors:
     - server error
     - LocalDataError: no ration selected
     */
    func addToRation(food: FoodItem, completion: @escaping RequestCompletion) {
        guard presentedRationIndex != -1 else {
            completion(nil, ResponseError(code: -1, message: ERROR_RATION_INVALID_INDEX))
            return
        }
        let curRation = diary[presentedRationIndex]
        curRation.ration.append(food)
        
        NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
        update(ration: curRation) { (success, err) in
            completion(success, err)
        }
    }
    
    /**
     senf request to prepare rations for several days in advance
     
     possible errors:
     - server error
     - json decoding error
     */
    func prepRation(forDays days: Int, completion: @escaping RequestCompletion) {
        diary = []
        prepRequest(days: days, completion: completion) { (json) in
            do {
                let ration = try Ration(json: json)
                self.diary.append(ration)
            } catch let err {
                completion(nil, ResponseError(code: -1, message: err.localizedDescription))
            }
        }
    }
    
    private func changePortion(id: String, completion: @escaping RequestCompletion, portionChangeClosure: (_: Double, _: Double, _: Double) -> (Double)) {
        
        guard presentedRationIndex != -1 else {
            completion(nil, ResponseError(code: -1, message: ERROR_RATION_INVALID_INDEX))
            return
        }
        let curRation = diary[presentedRationIndex]
        
        guard let row = curRation.ration.firstIndex(where: { $0.food!._id == id }) else {
            completion(nil, ResponseError(code: -1, message: "Unable to update item: id \(id) not found"))
            return
        }
        
        let food = curRation.ration[row]
        let delta = food.delta ?? 0
        let available = food.available ?? 0
        let portion = food.portion ?? 0
        let deltaWeight = portionChangeClosure(portion, delta, available)
        
        curRation.ration[row].updateWeight(delta: deltaWeight)
        self.updateNutrition(forRation: curRation, nutritionFacts: food.food!.nutrition, portion: deltaWeight)
        
        update(ration: curRation) { (response, error) in
            if error == nil {
                NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
            }
            
            completion(response, error)
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

extension RationService: Service {
    @objc func loggedOutHandler() {
        reset()
    }
    
    func reset() {
        diary = []
        presentedRationIndex = -1
        todayRationIndex = -1
    }
    
    /**
     request last `n` rations
     
     possible errors:
     - server error
     - RequestError: corrupted data or no data
     */
    func get(completion: @escaping RequestCompletion) {
        diary = []
        
        get(completion: completion) { (json) in
            guard let dateStr = json["date"].string else {
                completion(nil, ResponseError(code: -1, message: "\(ERROR_MSG_INVALID_RESPONSE): Date is missed"))
                return
            }
            
            let formatter = ISO8601DateFormatter()
            guard let date = formatter.date(from: dateStr) else {
                completion(nil, ResponseError(code: -1, message: "\(ERROR_MSG_INVALID_RESPONSE): Wrong date format"))
                return
            }
            
            do {
                let ration = try Ration(json: json)
                self.diary.append(ration)
                
                let day = 24.0 * 60 * 60
                let interval = date.timeIntervalSinceNow
                if interval < 0 && day + interval >= 0 {
                    self.todayRationIndex = self.diary.count - 1
                    self.presentedRationIndex = self.todayRationIndex
                }
            } catch let err {
                completion(nil, ResponseError(code: -1, message: "\(ERROR_MSG_INVALID_RESPONSE):  \(err.localizedDescription)"))
            }
        }
    }
}
