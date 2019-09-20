//
//  DataService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 20/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FoodService {
    static let instance = FoodService()
    
    private(set) public var foods: [FoodItem] = []
    
    func clearData() {
        foods = []
    }
    
    func getFood (handler: @escaping CompletionHandler) {
        foods = []
        get(appendHandler: { (food) in
            self.foods.append(food)
        }, handler: handler)
    }
    
    func createNewFood (foodItem: FoodItem, handler: @escaping CompletionHandler) {
        insertFoodRequest(foodItem: foodItem) { (json) in
            if let json = json {
                let dailyPortion = DailyPortion(min: (foodItem.dailyPortion.min ?? 0), max: (foodItem.dailyPortion.max ?? 0))
                
                self.insert(forId: json["id"].stringValue, available: foodItem.available ?? 0.0, dailyPortion: dailyPortion, handler: handler)
            } else {
                handler(false, nil)
            }
        }
    }
    
    func insert (forId id: String, available: Double, dailyPortion: DailyPortion, handler: @escaping CompletionHandler) {
        insertRequest(forId: id, available: available, dailyPortion: dailyPortion, appendHandler: { (food) in
            self.foods.append(food)
        }, handler: handler)
    }
    
    func removeItem (index: Int, handler: CompletionHandler, requestHandler: @escaping CompletionHandler) {
        print(" # remove \(index), before:")
        foods.forEach { (food) in
            print(food.food?.name)
        }
        
        guard index < foods.count && index >= 0 else { handler(false, nil); return }
        guard let food = foods[index].food, let id = food._id else { handler(false, nil); return }
        deleteRequest(foodId: id, handler: requestHandler)
        foods.remove(at: index)
        handler(true, nil)
        
        print(" # after:")
        foods.forEach { (food) in
            print(food.food?.name)
        }
    }
    
    func setSelected(name: String) { // no completion handler since it called from table view cell
        if let row = foods.firstIndex(where: { $0.food!.name == name }) {
            let daily = foods[row].dailyPortion
            if daily.min == nil || daily.min! == 0 {
                if let delta = foods[row].delta, delta > 0 {
                    foods[row].dailyPortion.min = delta
                } else {
                    foods[row].dailyPortion.min = 1
                }
            } else {
                foods[row].dailyPortion.min = 0
            }
            
            do {
                let data = try JSONEncoder().encode(foods[row])
                let json = try JSON(data: data)
                
                updateRequest(data: json) { (success, error) in
                    NotificationCenter.default.post(name: NOTIF_FOOD_DATA_CHANGED, object: nil, userInfo: ["index": row])
                }
            } catch let err {
                debugPrint(" # update food error: \(err)")
            }
        }
    }
    
    func updateFood(food: FoodItem, handler: @escaping CompletionHandler) {
        guard let row = foods.firstIndex(where: { $0.food!._id == food.food!._id }) else { return }
        
        do {
            let data = try JSONEncoder().encode(food)
            let json = try JSON(data: data)
            
            updateRequest(data: json) { (success, error) in
                if success {
                    self.foods[row] = food
                }
                handler(success, error)
            }
        } catch let err {
            debugPrint(" # update food error: \(err)")
            handler(false, err)
        }
    }
}
