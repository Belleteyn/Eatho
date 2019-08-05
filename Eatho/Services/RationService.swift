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
    
    func removeItem(index: Int) {
        ration.remove(at: index)
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
                    guard let json = JSON(data).array else { return }
                    self.ration = []
                    
                    for item in json {
                        self.ration.append(self.parseFoodItem(item: item))
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
