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
    
    func addItem(name: String, handler: @escaping CompletionHandler) {
        insert(key: name, value: false)
        uploadData(handler: handler)
    }
    
    func removeItemFromShopList(index: Int, handler: @escaping CompletionHandler) {
        if index < shoppingList.count && index >= 0 {
            shoppingList.remove(at: index)
            uploadData(handler: handler)
        } else {
            print("error: invalid index \(index) for shopping list array (\(shoppingList.count))")
        }
    }
    
    func removeItemFromRecent(index: Int, handler: @escaping CompletionHandler) {
        if index < mostRecentList.count && index >= 0 {
            mostRecentList.remove(at: index)
            uploadData(handler: handler)
        }
    }
    
    func moveItemFromRecentToShopList(recentIndex index: Int, handler: @escaping CompletionHandler) {
        if index < mostRecentList.count && index >= 0 {
            let key = mostRecentList[index]
            if let sListIndex = shoppingList.firstIndex(where: { $0.0 == key }) {
                shoppingList[sListIndex].value = false
            } else {
                insert(key: key, value: false)
            }
            
            mostRecentList.remove(at: index)
            uploadData(handler: handler)
        }
    }
    
    func chageSelectionInShoppingList(key: String, value: Bool, handler: @escaping CompletionHandler) {
        if let index = shoppingList.firstIndex(where: { $0.0 == key }) {
            shoppingList[index].value = value
        }
        
        if value {
            mostRecentList = mostRecentList.filter { $0 != key } //remove prev occurances if any
            mostRecentList.append(key)
        }
        
        uploadData(handler: handler)
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
    func requestData(handler: @escaping CompletionHandler) {
        let query = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token
        ]
        
        Alamofire.request(URL_SHOPPING_LIST_GET, method: .get, parameters: query, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch (response.result) {
            case .success:
                guard let data = response.data else {
                    handler(false, RequestError(localizedDescription: ERROR_MSG_EMPTY_RESPONSE))
                    return
                }
                
                let json = JSON(data)
                
                if let shoppingList = json["shoppingList"].arrayObject as? [String] {
                    shoppingList.forEach({ (name) in
                        self.insert(key: name, value: false)
                    })
                }
                
                if let recent = json["recentPurchases"].arrayObject as? [String] {
                    self.mostRecentList = recent
                }
                
                handler(true, nil)
            case .failure(let error):
                handler(false, error)
            }
        }
    }
    
    /**
     requests food list with names containing `searchArg`
     
     possible errors:
     - server error
     */
    func uploadData(handler: @escaping CompletionHandler) {
        var uploadingList: [String] = []
        shoppingList.forEach { if !$0.1 { uploadingList.append($0.0) } }
        
        let body: [String: Any] = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "shoppingList": uploadingList,
            "recentPurchases": mostRecentList
        ]
        
        Alamofire.request(URL_SHOPPING_LIST_UPD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch (response.result) {
            case .success:
                handler(true, nil)
            case .failure(let error):
                debugPrint(error)
                handler(false, error)
            }
        }
    }
}
