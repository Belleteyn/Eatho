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
    
    /**
     fetch available food array, replace old one
     
     possible errors:
      - server error
      - json encoding error
      - LocalDataError (about json encoding too)
     */
    
    func getFood (handler: @escaping CompletionHandler) {
        get(dataHandler: { (foods) in
            self.foods = foods
        }, handler: handler)
    }
    
    /**
     adds new food to common Food table and inserts in user's available foods
     
     possible errors:
     - server error
     - LocalDataError (no data)
     - RequestError
     */
    
    func createNewFood (foodItem: FoodItem, handler: @escaping CompletionHandler) {
        insertFoodRequest(foodItem: foodItem) { (json, err) in
            if err != nil {
                handler(false, err)
                return
            }
            
            if let json = json {
                let dailyPortion = DailyPortion(min: (foodItem.dailyPortion.min ?? 0), max: (foodItem.dailyPortion.max ?? 0))
                
                self.insert(forId: json["id"].stringValue, available: foodItem.available ?? 0.0, dailyPortion: dailyPortion, handler: handler)
            } else {
                handler(false, RequestError(message: "got empty data from server"))
            }
        }
    }
    
    /**
     inserts food with `id` in user's available foods
     
     all weight measures are required to be standard (in grams)
     
     possible errors:
     - server error
     - RequestError
     */
    
    func insert (forId id: String, available: Double, dailyPortion: DailyPortion, handler: @escaping CompletionHandler) {
        insertRequest(forId: id, available: available, dailyPortion: dailyPortion, appendHandler: { (food) in
            self.foods.insert(food, at: 0)
        }, handler: handler)
    }
    
    /**
     removes item from available food array by index
     
     possible errors:
     - server error
     - LocalDataError
     */
    
    func removeItem (index: Int, handler: CompletionHandler, requestHandler: @escaping CompletionHandler) {
        guard index < foods.count && index >= 0 else {
            handler(false, LocalDataError(errDesc: "Invalid index to remove food item", failedIndex: index))
            return
        }
        
        guard let food = foods[index].food, let id = food._id else {
            handler(false, LocalDataError(errDesc: "Failed to fetch food id, food will not be removed", failedIndex: index))
            return
        }
        
        deleteRequest(foodId: id, handler: requestHandler)
        foods.remove(at: index)
        handler(true, nil)
    }
    
    /**
     updates corresponded food item in available array
     
     possible errors:
     - server error
     - LocalDataError (not found locally)
     - json encoding error
     */
    
    func updateFood(food: FoodItem, handler: @escaping CompletionHandler) {
        guard let row = foods.firstIndex(where: { $0.food!._id == food.food!._id }) else {
            handler(false, LocalDataError(errDesc: "Failed to find food with id \(String(describing: food.food?._id)) to update", failedIndex: nil))
            return
        }
        
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
            handler(false, err)
        }
    }
}
