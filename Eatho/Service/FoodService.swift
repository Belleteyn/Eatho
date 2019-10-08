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
    
    init() {
        self.subscribeLoggedOut(selector: #selector(loggedOutHandler))
    }
    
    /**
     adds new food to common Food table and inserts in user's available foods
     
     possible errors:
     - server error
     - LocalDataError (no data)
     - RequestError
     */
    
    func createNewFood (foodItem: FoodItem, completion: @escaping RequestCompletion) {
        insertFoodRequest(foodItem: foodItem, completion: completion) { (json) in
            let dailyPortion = DailyPortion(min: (foodItem.dailyPortion.min ?? 0), max: (foodItem.dailyPortion.max ?? 0))
            
            self.insert(forId: json["id"].stringValue, available: foodItem.available ?? 0.0, dailyPortion: dailyPortion, completion: completion)
        }
    }
    
    /**
     inserts food with `id` in user's available foods
     
     all weight measures are required to be standard (in grams)
     
     possible errors:
     - server error
     - RequestError
     */
    
    func insert (forId id: String, available: Double, dailyPortion: DailyPortion, completion: @escaping RequestCompletion) {
        insertRequest(forId: id, available: available, dailyPortion: dailyPortion, appendHandler: { (food) in
            self.foods.insert(food, at: 0)
        }, completion: completion)
    }
    
    /**
     removes item from available food array by index
     
     possible errors:
     - server error
     - LocalDataError
     */
    
    func removeItem (index: Int, completion: @escaping RequestCompletion) -> Bool {
        guard index < foods.count && index >= 0 else { return false }
        guard let food = foods[index].food, let id = food._id else { return false }
        
        deleteRequest(foodId: id, completion: completion)
        foods.remove(at: index)
        
        return true
    }
    
    /**
     updates corresponded food item in available array
     
     possible errors:
     - server error
     - LocalDataError (not found locally)
     - json encoding error
     */
    
    func updateFood(food: FoodItem, completion: @escaping RequestCompletion) {
        guard let row = foods.firstIndex(where: { $0.food!._id == food.food!._id }) else {
            completion(nil, ResponseError(code: -1, message: "Failed to find food with id \(String(describing: food.food?._id)) to update"))
            return
        }
        
        do {
            let data = try JSONEncoder().encode(food)
            let json = try JSON(data: data)
            
            updateRequest(data: json) { (response, error) in
                if error == nil {
                    self.foods[row] = food
                }
                
                completion(response, error)
            }
        } catch let err {
            completion(nil, ResponseError(code: -1, message: "\(ERROR_MSG_FAILED_JSON_ENCODE)\n\(err.localizedDescription)"))
        }
    }
}

extension FoodService: Service {
    @objc func loggedOutHandler() {
        reset()
    }
    
    func reset() {
        foods = []
    }
    
    /**
     fetch available food array, replace old one
     
     possible errors:
      - server error
      - json encoding error
      - LocalDataError (about json encoding too)
     */
    func get(completion: @escaping RequestCompletion) {
        get(dataHandler: { (foods) in
            self.foods = foods
        }, completion: completion)
    }
}
