//
//  FoodServiceNetworkExtension.swift
//  Eatho
//
//  Created by Серафима Зыкова on 03/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension FoodService {
    
    func get(dataHandler: @escaping (_: [FoodItem]) -> (), completion: @escaping RequestCompletion) {
        let params = AuthService.instance.credentials.dictionaryObject
        
        Network.get(url: URL_AVAILABLE, query: params) { (response, error) in
            if let data = response?.data {
                do {
                    var foodArr = [FoodItem]()
                    if let jsonArr = try JSON(data: data).array {
                        for item in jsonArr {
                            let food = FoodItem(json: item)
                            foodArr.append(food)
                        }
                        
                        dataHandler(foodArr.reversed())
                    }
                } catch let err {
                    completion(response, ResponseError(code: -1, message: "\(ERROR_MSG_INVALID_RESPONSE)\n\(err.localizedDescription)"))
                    return
                }
            }
            
            completion(response, error)
        }
    }
    
    func insertFoodRequest(foodItem: FoodItem, completion: @escaping RequestCompletion, dataHandler: @escaping (_ json: JSON) -> ()) {
        guard let foodJson = foodItem.toJson(), let jsonDict = foodJson.dictionaryObject else {
            completion(nil, ResponseError(code: -1, message: ERROR_MSG_FAILED_JSON_ENCODE))
            return
        }
        
        let body: [String: Any] = [
            "email": AuthService.instance.email ?? "",
            "token": AuthService.instance.token ?? "",
            "food": jsonDict
        ]
        
        Network.post(url: URL_ADD_FOOD, body: body) { (response, error) in
            if let data = response?.data {
                do {
                    let json = try JSON(data: data)
                    dataHandler(json)
                } catch let err {
                    completion(nil, ResponseError(code: -1, message: "\(ERROR_MSG_INVALID_RESPONSE)\n\(err.localizedDescription)"))
                    return
                }
                
                completion(response, error)
            }
        }
    }
    
    func insertRequest(forId id: String, available: Double, dailyPortion: DailyPortion, appendHandler: @escaping (_ : FoodItem) -> (), completion: @escaping RequestCompletion) {
        
        var info: [String: Any] = [
            "id": id,
            "available": available
        ]
        if let min = dailyPortion.min {
            info["min"] = min
        }
        if let max = dailyPortion.max {
            info["max"] = max
        }
        
        let body: [String: Any] = [
            "email": AuthService.instance.email ?? "",
            "token": AuthService.instance.token ?? "",
            "info": info
        ]
        
        Network.post(url: URL_AVAILABLE, body: body) { (response, error) in
            if let data = response?.data {
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let food = FoodItem(json: item)
                            appendHandler(food)
                        }
                    }
                    
                    NotificationCenter.default.post(name: NOTIF_FOOD_DATA_CHANGED, object: nil)
                } catch let err {
                    completion(nil, ResponseError(code: -1, message: "\(ERROR_MSG_INVALID_RESPONSE)\n\(err.localizedDescription)"))
                    return
                }
            }
            
            completion(response, error)
        }
    }
    
    func updateRequest(data: JSON, completion: @escaping RequestCompletion) {
        let body: JSON = [
            "email": AuthService.instance.email ?? "",
            "token": AuthService.instance.token ?? "",
            "food": data
        ]
        
        Network.put(url: URL_AVAILABLE, body: body.dictionaryObject, completion: completion)
    }
    
    func deleteRequest(foodId: String, completion: @escaping RequestCompletion) {
        let body = [
            "email": AuthService.instance.email ?? "",
            "token": AuthService.instance.token ?? "",
            "foodId": foodId
        ]
        
        Network.delete(url: URL_AVAILABLE, body: body, completion: completion)
    }
}
