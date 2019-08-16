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

class DataService {
    static let instance = DataService()
    
    private(set) public var foods: [FoodItem] = []
    
    func clearData() {
        foods = []
    }
    
    func removeItem(index: Int) {
        guard index < foods.count && index >= 0 else { return }
        guard let id = foods[index]._id else { return }
        removeFromAvailable(foodId: id)
        foods.remove(at: index)
    }
    
    func setSelected(name: String) {
        if let row = foods.firstIndex(where: { $0.name == name }) {
            let daily = foods[row].dailyPortion
            
            if daily.min == nil || daily.min! == 0 {
                guard let delta = foods[row].delta else { return }
                foods[row].dailyPortion.min = Int(delta)
            } else {
                foods[row].dailyPortion.min = 0
            }
        }
        NotificationCenter.default.post(name: NOTIF_FOOD_DATA_CHANGED, object: nil)
    }
    
    func updateFood(id: String, available: Double?, min: Int?, max: Int?, delta: Double?, handler: @escaping CompletionHandler) {
        guard let row = foods.firstIndex(where: { $0._id == id }) else { return }
        var updJson: Dictionary<String, Any> = [ "_id": id ]
        
        if available != nil {
            foods[row].availableWeight = available!
            updJson["available"] = available!
        }
        
        if min != nil {
            foods[row].dailyPortion.min = min!
            updJson["dailyPortion"] = ["min": min!]
        }
        
        if max != nil {
            foods[row].dailyPortion.max = max!
            updJson["dailyPortion"] = ["max": max!]
        }
        
        if delta != nil {
            foods[row].delta = delta!
            updJson["delta"] = delta!
        }
        
        //todo send data
        handler(true)
    }
    
    func requestAvailableFoodItems(handler: @escaping CompletionHandler) {
        let params = AuthService.instance.credentials
        
        Alamofire.request(URL_AVAILABLE, method: .get, parameters: params.dictionaryObject, encoding: URLEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    
                    if let jsonArr = try JSON(data: data).array {
                        self.foods = [] //clear before append
                        
                        for item in jsonArr {
                            let food = FoodItem(json: item)
                            self.foods.append(food)
                        }
                        
                        handler(true)
                    }
                } catch let error {
                    debugPrint("available foods json parsing error:", error)
                    handler(false)
                }
                
            case .failure(let error):
                debugPrint(error as Any)
                handler(false)
            }
        }
    }
    
    func addNewFood(food: FoodItem, handler: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "food": [
                "name": food.name!,
                "type": food.type!,
                "calories": food.nutrition.calories.total!,
                "carbs": food.nutrition.carbs.total!,
                "fats": food.nutrition.fats.total!,
                "proteins": food.nutrition.proteins!,
                "gi": food.gi!
            ]
        ]
        
        Alamofire.request(URL_ADD_FOOD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else { handler(false); return }
                let json = JSON(data)
                let body: [String: Any] = [
                    "email": AuthService.instance.userEmail,
                    "token": AuthService.instance.token,
                    "info": [
                        "id": json["id"].stringValue,
                        "available": food.availableWeight ?? 0,
                        "min": (food.dailyPortion.min ?? 0),
                        "max": (food.dailyPortion.max ?? 0),
                        "preferred": (food.dailyPortion.preferred ?? 0)
                    ]
                ]
                
                Alamofire.request(URL_AVAILABLE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data else { handler(false); return }
                        let json = JSON(data)
                        let food = FoodItem(json: json)
                        self.foods.append(food)
                        
                        NotificationCenter.default.post(name: NOTIF_FOOD_DATA_CHANGED, object: nil)
                        handler(true)
                    case.failure(let error):
                        debugPrint(error)
                        handler(true)
                    }
                }
            case .failure(let error):
                debugPrint(error)
                handler(true)
            }
        }
    }
    
    func removeFromAvailable(foodId: String) {
        let body = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "foodId": foodId
        ]
        
        Alamofire.request(URL_AVAILABLE, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                print("item removed sucessfully from available")
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
