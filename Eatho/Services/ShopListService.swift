//
//  ShopListService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 04/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ShopListService {
    static let instance = ShopListService()
    
    private (set) public var list: [String : Bool] = [:]
    private (set) public var mostRecentList: [String] = []
    
    func addItem(name: String) {
        list[name] = false
    }
    
    func selectRecent(name: String) {
        list[name] = false
        mostRecentList = mostRecentList.filter { $0 != name }
        
        NotificationCenter.default.post(name: NOTIF_SHOPPING_LIST_DATA_CHAGNED, object: nil)
    }
    
    func chageSelectionInShoppingList(key: String, value: Bool) {
        list[key] = value
        
        if value {
            mostRecentList = mostRecentList.filter { $0 != key } //remove prev occurances if any
            mostRecentList.append(key)
        }
    }
    
    func requestData() {
        let query = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token
        ]
        
        Alamofire.request(URL_SHOPPING_LIST_GET, method: .get, parameters: query, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch (response.result) {
            case .success:
                if let data =  response.data {
                    let json = JSON(data)
                    
                    if let shoppingList = json["shoppingList"].dictionaryObject as? [String : Bool] {
                        self.list = shoppingList
                    }
                    
                    if let recent = json["recentPurchases"].arrayObject as? [String] {
                        self.mostRecentList = recent
                    }
                    
                    NotificationCenter.default.post(name: NOTIF_SHOPPING_LIST_DATA_CHAGNED, object: nil)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func uploadData() {
        list = list.filter({ !$1 })
        
        let body: [String: Any] = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "shoppingList": list,
            "recentPurchases": mostRecentList
        ]
        
        Alamofire.request(URL_SHOPPING_LIST_UPD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch (response.result) {
            case .success:
                print("shopping list updated successfully")
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
