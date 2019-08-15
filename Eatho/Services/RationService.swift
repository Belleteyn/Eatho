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
    
    public private(set) var diary = [Ration]()
    public private(set) var nutrition = NutritionFacts(calories: 0, proteins: 0, carbs: 0, fats: 0)
    public private(set) var currentRation: [FoodItem] = [] {
        didSet {
            updateRationInfo()
        }
    }
    
    func clearData() {
        currentRation = []
    }
    
    func removeItem(index: Int) {
        currentRation.remove(at: index)
        updateRationInfo()
        NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
    }
    
    func incPortion(name: String) {
        if let row = self.currentRation.firstIndex(where: { $0.name == name }) {
            let food = currentRation[row]
            let delta = food.delta ?? 0
            let available = food.availableWeight ?? 0
            let portion = food.portion ?? 0
            if portion + delta < (available) {
                currentRation[row].updateWeight(delta: delta)
            } else {
                currentRation[row].updateWeight(delta: (available - portion))
            }
            
            updateRationInfo()
            NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
        }
    }
    
    func decPortion(name: String) {
        if let row = self.currentRation.firstIndex(where: { $0.name == name }) {
            let food = currentRation[row]
            let delta = food.delta ?? 0
            let portion = food.portion ?? 0
            if portion - delta >= 0 {
                currentRation[row].updateWeight(delta: -delta)
            } else {
                currentRation[row].updateWeight(delta: -portion)
            }
            
            updateRationInfo()
            NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
        }
    }
    
    private func updateRationInfo() {
        nutrition.reset()
        
        for food in currentRation {
            nutrition.addPortion(food: food)
        }
    }
    
    func requestRation(handler: @escaping CompletionHandler) {
        let query: [String : Any] = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "count": 10
        ]
        
        Alamofire.request(URL_RATION, method: .get, parameters: query, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    guard let json = JSON(data).array else { return }
                    self.currentRation = []
                    
                    
                    let isoFormatter = ISO8601DateFormatter()
                    let today = isoFormatter.string(from: Date()).prefix(10)
                    
                    print(today)
                    for item in json {
                        guard let dateStr = item["date"].string else { continue }
                        do {
                            let data = try item.rawData()
                            let ration = try JSONDecoder().decode(Ration.self, from: data)
                            self.diary.append(ration)
                            
                            if dateStr == today {
                                self.nutrition = ration.nutrition
                                self.currentRation = ration.ration
                            }
                        } catch let err {
                            debugPrint(err)
                        }
                    }
                    
                    handler(true)
                }
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
}
