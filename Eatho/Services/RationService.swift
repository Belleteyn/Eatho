//
//  RetionService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RationService {
    static let instance = RationService()
    
    var ration: [FoodItem] = []
    
    func clearData() {
        ration = []
    }
    
    func requestRation(handler: @escaping CompletionHandler) {
        let query = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token
        ]
        
        Alamofire.request(URL_RATION, method: .get, parameters: query, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    let json = JSON(data)
                    
                    self.ration = []
                    guard let ration = json["ration"].array else { return }
                    print(ration)
                    
                    for item in ration {
                        self.ration.append(self.parseFoodItem(item: item))
                        print(self.ration.count)
                    }
                    
                    handler(true)
                }
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
    
    func uploadRation() {
        
    }
    
    private func parseFoodItem(item: JSON) -> FoodItem {
        let name = item["food"]["name"]["en"].string ?? ""
        let type = item["food"]["type"].string ?? ""
        let calories = item["food"]["nutrition"]["calories"]["total"].double ?? 0
        let carbs = item["food"]["nutrition"]["carbs"]["total"].double ?? 0
        let fats = item["food"]["nutrition"]["fats"]["total"].double ?? 0
        let proteins = item["food"]["nutrition"]["proteins"].double ?? 0
        
        let weight = item["available"].int ?? 0
        let portion = item["portion"].int ?? 0
        let delta = item["delta"].int ?? 0
        
        return FoodItem(name: name, type: type, availableWeight: Double(weight), calories: calories, proteins: proteins, carbs: carbs, fats: fats, gi: 0, min: 0, max: 0, preferred: 0, portion: portion, delta: delta)
    }
}
