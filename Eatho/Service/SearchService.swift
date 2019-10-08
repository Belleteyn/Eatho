//
//  SearchService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchService {
    static let instance = SearchService()
    
    private(set) public var foods = [Food]()
    
    func clearData() {
        foods = []
    }
    
    /**
     requests food list with names containing `searchArg`
     
     possible errors:
     - server error
     - RequestError
     */
    func requestSearch(searchArg: String, completion: @escaping RequestCompletion) {
        var params = [ "args": searchArg ]
        if let code = Locale.current.languageCode {
            params["lang"] = code
        }
        
        Network.get(url: URL_SEARCH_FOOD, query: params) { (response, error) in
            if let data = response?.data {
                do {
                    if let jsonArr = try JSON(data: data).array {
                        self.foods = [] //clear before
                        for item in jsonArr {
                            let food = Food(json: item)
                            self.foods.append(food)
                        }
                    }
                } catch let error {
                    completion(nil, ResponseError(code: -1, message: "\(ERROR_MSG_INVALID_RESPONSE)\n\(error.localizedDescription)"))
                    return
                }
                
                completion(response, error)
            }
        }
    }
}
