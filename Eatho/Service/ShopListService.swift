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
    
    private (set) public var shoppingList: [(key: String, value: Bool)] = []
    private (set) public var mostRecentList: [String] = []
    
    private func insert(key: String, value: Bool) {
        if let greater = shoppingList.firstIndex(where: { $0.0 > key } ) {
            let insertIndex = shoppingList.index(before: greater + 1)
            shoppingList.insert((key: key, value: value), at: insertIndex)
        } else {
            shoppingList.append((key: key, value: value))
        }
    }
    
    func addItem(name: String, completion: @escaping RequestCompletion) {
        insert(key: name, value: false)
        uploadData(completion: completion)
    }
    
    func removeItemFromShopList(index: Int, completion: @escaping RequestCompletion) {
        if index < shoppingList.count && index >= 0 {
            shoppingList.remove(at: index)
            uploadData(completion: completion)
        } else {
            print("error: invalid index \(index) for shopping list array (\(shoppingList.count))")
        }
    }
    
    func removeItemFromRecent(index: Int, completion: @escaping RequestCompletion) {
        if index < mostRecentList.count && index >= 0 {
            mostRecentList.remove(at: index)
            uploadData(completion: completion)
        }
    }
    
    func moveItemFromRecentToShopList(recentIndex index: Int, completion: @escaping RequestCompletion) {
        if index < mostRecentList.count && index >= 0 {
            let key = mostRecentList[index]
            if let sListIndex = shoppingList.firstIndex(where: { $0.0 == key }) {
                shoppingList[sListIndex].value = false
            } else {
                insert(key: key, value: false)
            }
            
            mostRecentList.remove(at: index)
            uploadData(completion: completion)
        }
    }
    
    func chageSelectionInShoppingList(key: String, value: Bool, completion: @escaping RequestCompletion) {
        if let index = shoppingList.firstIndex(where: { $0.0 == key }) {
            shoppingList[index].value = value
        }
        
        if value {
            mostRecentList = mostRecentList.filter { $0 != key } //remove prev occurances if any
            mostRecentList.append(key)
        }
        
        uploadData(completion: completion)
    }
    
    func clearData() {
        shoppingList = []
        mostRecentList = []
    }
    
    /**
     requests shopping list
     
     possible errors:
     - server error
     - RequestError
     */
    func requestData(completion: @escaping RequestCompletion) {
        let query = AuthService.instance.credentials
        
        Network.get(url: URL_SHOPPING_LIST_GET, query: query.dictionaryObject) { (response, error) in
            if let data = response?.data {
                let json = JSON(data)
                
                if let shoppingList = json["shoppingList"].arrayObject as? [String] {
                    shoppingList.forEach({ (name) in
                        self.insert(key: name, value: false)
                    })
                }
                
                if let recent = json["recentPurchases"].arrayObject as? [String] {
                    self.mostRecentList = recent
                }
            }
            
            completion(response, error)
        }
    }
    
    /**
     requests food list with names containing `searchArg`
     
     possible errors:
     - server error
     */
    func uploadData(completion: @escaping RequestCompletion) {
        var uploadingList: [String] = []
        shoppingList.forEach { if !$0.1 { uploadingList.append($0.0) } }
        
        var body = AuthService.instance.credentials
        body["shoppingList"] = JSON(uploadingList)
        body["recentPurchases"] = JSON(mostRecentList)
        
        Network.post(url: URL_SHOPPING_LIST_UPD, body: body.dictionaryObject, completion: completion)
    }
}
