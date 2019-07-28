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
    
    private(set) public var foods: [FoodItem] = [
//        FoodItem(name: "Parmesan cheese", icon: "content_item_cheese.png", weight: 60, calories: 431, proteins: 38, carbs: 4.1, fats: 29),
//        FoodItem(name: "Grape", icon: "content_item_grape.png", weight: 70, calories: 65, proteins: 0.6, carbs: 16.8, fats: 0.2),
//        FoodItem(name: "Avocado", icon: "content_item_avocado.png", weight: 120, calories: 160, proteins: 2, carbs: 22, fats: 76),
//        FoodItem(name: "Chicken", icon: "content_item_chiken.png", weight: 100, calories: 170, proteins: 16, carbs: 0, fats: 14)
    ]
    
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
                        for item in jsonArr {
                            let name = item["food"]["name"]["en"].string ?? ""
                            let icon = "content_item_\(item["food"]["type"]).png"
                            let weight = item["available"].int ?? 0
                            let calories = item["food"]["nutrition"]["calories"]["total"].double ?? 0
                            let carbs = item["food"]["nutrition"]["carbs"]["total"].double ?? 0
                            let fats = item["food"]["nutrition"]["fats"]["total"].double ?? 0
                            let proteins = item["food"]["nutrition"]["proteins"].double ?? 0
                            
                            let food = FoodItem(name: name, icon: icon, weight: Double(weight), calories: calories, proteins: proteins, carbs: carbs, fats: fats)
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
}
