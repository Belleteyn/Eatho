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
    public private(set) var nutrition = Nutrition(calories: 0, proteins: 0, carbs: 0, fats: 0)
    public private(set) var currentRation: [FoodItem] = []
    
    func resetData() {
        diary = []
        nutrition = Nutrition(calories: 0, proteins: 0, carbs: 0, fats: 0)
        currentRation = []
    }
    
    func removeItem(index: Int) {
        updateNutrition(delta: currentRation[index].food!.nutrition, portion: currentRation[index].portion!, inc: false)
        currentRation.remove(at: index)
        
        NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
    }
    
    private func updateNutrition(delta: NutritionFacts, portion: Double, inc: Bool) {
        let kcal = delta.calories.total! * portion / 100, c = delta.carbs.total! * portion / 100, f = delta.fats.total! * portion / 100, p = delta.proteins! * portion / 100
        
        nutrition.calories += inc ? kcal : -kcal
        nutrition.carbs += inc ? c : -c
        nutrition.fats += inc ? f : -f
        nutrition.proteins += inc ? p : -p
    }
    
    func incPortion(name: String) {
        if let row = self.currentRation.firstIndex(where: { $0.food!.name == name }) {
            let food = currentRation[row]
            let delta = food.delta ?? 0
            let available = food.available ?? 0
            let portion = food.portion ?? 0
            
            updateNutrition(delta: currentRation[row].food!.nutrition, portion: currentRation[row].portion!, inc: false)
            if portion + delta < (available) {
                currentRation[row].updateWeight(delta: delta)
            } else {
                currentRation[row].updateWeight(delta: (available - portion))
            }
            updateNutrition(delta: currentRation[row].food!.nutrition, portion: currentRation[row].portion!, inc: true)
            
            NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
        }
    }
    
    func decPortion(name: String) {
        if let row = self.currentRation.firstIndex(where: { $0.food!.name == name }) {
            let food = currentRation[row]
            let delta = food.delta ?? 0
            let portion = food.portion ?? 0
            
            updateNutrition(delta: currentRation[row].food!.nutrition, portion: currentRation[row].portion!, inc: false)
            if portion - delta >= 0 {
                currentRation[row].updateWeight(delta: -delta)
            } else {
                currentRation[row].updateWeight(delta: -portion)
            }
            updateNutrition(delta: currentRation[row].food!.nutrition, portion: currentRation[row].portion!, inc: true)
            
            NotificationCenter.default.post(name: NOTIF_RATION_DATA_CHANGED, object: nil)
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
                self.resetData()
                
                if let data = response.data {
                    guard let json = JSON(data).array else { return }
                    
                    let formatter = ISO8601DateFormatter()
                    let day = 24.0 * 60 * 60
                    
                    for item in json {
                        guard let dateStr = item["date"].string, let date = formatter.date(from: dateStr) else { continue }
                        
                        let ration = Ration(json: item)
                        self.diary.append(ration)
                        
                        let interval = date.timeIntervalSinceNow
                        if interval < 0 && day + interval >= 0 {
                            self.nutrition.set(nutrition: ration.nutrition)
                            self.currentRation = ration.ration
                        }
                    }
                    
                    handler(true)
                }
            case .failure(let err):
                debugPrint(err)
                handler(false)
            }
        }
    }
    
    func prepRation(forDays days: Int, handler: @escaping CompletionHandler) {
        let body: [String : Any] = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "count": days
        ]
        
        Alamofire.request(URL_RATION, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            
            do {
                guard let data = response.data, let json = try JSON(data: data).array else { handler(false); return }
                self.diary = []
                for item in json {
                    self.diary.append(Ration(json: item))
                }
                
                handler(true)
            } catch let err {
                debugPrint(err)
                handler(false)
            }
        }
    }
}
