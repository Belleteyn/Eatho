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
    
    func get(appendHandler: @escaping (_: FoodItem) -> (), handler: @escaping CompletionHandler) {
        let params = AuthService.instance.credentials
        
        Alamofire.request(URL_AVAILABLE, method: .get, parameters: params.dictionaryObject, encoding: URLEncoding.default, headers: JSON_HEADER).responseJSON { (response) in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    
                    if let jsonArr = try JSON(data: data).array {
                        for item in jsonArr {
                            let food = FoodItem(json: item)
                            appendHandler(food)
                        }
                        
                        handler(true, nil)
                    }
                } catch let error {
                    debugPrint("available foods json parsing error:", error)
                    handler(false, error)
                }
                
            case .failure(let error):
                debugPrint(error as Any)
                handler(false, error)
            }
        }
    }
    
    func insertFoodRequest(foodItem: FoodItem, handler: @escaping (_: JSON?) -> ()) {
        guard let food = foodItem.food else { handler(false); return }
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
                if let data = response.data {
                    handler(JSON(data))
                } else {
                    handler(nil)
                }
            case .failure(let error):
                debugPrint(error)
                handler(nil)
            }
        }
    }
    
    func insertRequest(forId id: String, available: Double, dailyPortion: DailyPortion, appendHandler: @escaping (_ : FoodItem) -> (), handler: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "info": [
                "id": id,
                "available": available,
                "min": dailyPortion.min!,
                "max": dailyPortion.max!,
                "preferred": dailyPortion.preferred!
            ]
        ]
        
        Alamofire.request(URL_AVAILABLE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else { handler(false, DataParseError.corruptedData); return }
                
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
                    debugPrint(err)
                    handler(false, err)
                }
            case.failure(let error):
                debugPrint(error)
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
                debugPrint(" # update food error: \(err)")
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
                debugPrint(error)
                handler(false, error)
            }
        }
    }
}
