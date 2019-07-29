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
    
    func requestAvailableFoodItems(handler: @escaping CompletionHandler) {
        let params = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token
        ]
        
        Alamofire.request(URL_AVAILABLE, method: .get, parameters: params, encoding: URLEncoding.default, headers: AUTH_HEADER).responseJSON { (response) in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        handler(false)
                        return
                    }
                    
                    if let jsonArr = try JSON(data: data).array {
                        self.foods = [] //clear before append
                        
                        for item in jsonArr {
                            let name = item["food"]["name"]["en"].string ?? ""
                            let type = item["food"]["type"].string ?? ""
                            let weight = item["available"].int ?? 0
                            let calories = item["food"]["nutrition"]["calories"]["total"].double ?? 0
                            let carbs = item["food"]["nutrition"]["carbs"]["total"].double ?? 0
                            let fats = item["food"]["nutrition"]["fats"]["total"].double ?? 0
                            let proteins = item["food"]["nutrition"]["proteins"].double ?? 0
                            
                            let food = FoodItem(name: name, type: type, availableWeight: Double(weight), calories: calories, proteins: proteins, carbs: carbs, fats: fats)
                            self.foods.append(food)
                            
                            handler(true)
                        }
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
                "name": food.name,
                "type": food.type,
                "calories": food.calories,
                "carbs": food.carbs,
                "fats": food.fats,
                "proteins": food.proteins,
                "gi": food.gi
            ]
        ]
        
        Alamofire.request(URL_ADD_FOOD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: AUTH_HEADER).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data)
                let body: [String: Any] = [
                    "email": AuthService.instance.userEmail,
                    "token": AuthService.instance.token,
                    "info": [
                        "id": json["id"].stringValue,
                        "available": food.availableWeight,
                        "min": food.min,
                        "max": food.max,
                        "preferred": food.preferred
                    ]
                ]
                
                Alamofire.request(URL_ADD_AVAILABLE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: AUTH_HEADER).responseJSON { (response) in
                    switch response.result {
                    case .success:
                        handler(true)
                    case.failure(let error):
                        debugPrint(error)
                        handler(false)
                    }
                }
            case .failure(let error):
                debugPrint(error)
                handler(false)
            }
        }
    }
}
