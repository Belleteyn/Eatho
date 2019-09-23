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
    
    func get(dataHandler: @escaping (_: [FoodItem]) -> (), handler: @escaping CompletionHandler) {
        let params = AuthService.instance.credentials
        
        Alamofire.request(URL_AVAILABLE, method: .get, parameters: params.dictionaryObject, encoding: URLEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        handler(false, LocalDataError(localizedDescription: ERROR_MSG_FAILED_JSON_ENCODE))
                        return
                    }
                    
                    var foodArr = [FoodItem]()
                    if let jsonArr = try JSON(data: data).array {
                        for item in jsonArr {
                            let food = FoodItem(json: item)
                            foodArr.append(food)
                        }
                        
                        dataHandler(foodArr.reversed())
                        handler(true, nil)
                    }
                } catch let error {
                    handler(false, error)
                }
                
            case .failure(let error):
                handler(false, error)
            }
        }
    }
    
    func insertFoodRequest(foodItem: FoodItem, handler: @escaping (_: JSON?, _: Error?) -> ()) {
        guard let foodJson = foodItem.toJson(), let jsonDict = foodJson.dictionaryObject else {
            handler(false, LocalDataError(localizedDescription: ERROR_MSG_FAILED_JSON_ENCODE))
            return
        }
        
        let body: [String: Any] = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "food": jsonDict
        ]
        
        Alamofire.request(URL_ADD_FOOD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    handler(JSON(data), nil)
                } else {
                    handler(nil, RequestError(localizedDescription: ERROR_MSG_EMPTY_RESPONSE))
                }
            case .failure(let error):
                debugPrint(error)
                handler(nil, error)
            }
        }
    }
    
    func insertRequest(forId id: String, available: Double, dailyPortion: DailyPortion, appendHandler: @escaping (_ : FoodItem) -> (), handler: @escaping CompletionHandler) {
        
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
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "info": info
        ]
        
        Alamofire.request(URL_AVAILABLE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    handler(false, RequestError(localizedDescription: ERROR_MSG_EMPTY_RESPONSE))
                    return
                }
                
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let food = FoodItem(json: item)
                            appendHandler(food)
                        }
                    }
                    
                    NotificationCenter.default.post(name: NOTIF_FOOD_DATA_CHANGED, object: nil)
                    handler(true, nil)
                } catch let err {
                    handler(false, err)
                }
            case.failure(let error):
                handler(false, error)
            }
        }
    }
    
    func updateRequest(data: JSON, handler: @escaping CompletionHandler) {
        let body: JSON = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "food": data
        ]
        
        Alamofire.request(URL_AVAILABLE, method: .put, parameters: body.dictionaryObject, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                handler(true, nil)
            case .failure(let err):
                handler(false, err)
            }
        }
    }
    
    func deleteRequest(foodId: String, handler: @escaping CompletionHandler) {
        let body = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "foodId": foodId
        ]
        
        Alamofire.request(URL_AVAILABLE, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                handler(true, nil)
            case .failure(let error):
                handler(false, error)
            }
        }
    }
}
