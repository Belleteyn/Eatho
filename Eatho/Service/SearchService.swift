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
    func requestSearch(searchArg: String, handler: @escaping CompletionHandler) {
        let params = [ "args": searchArg ]
        
        Alamofire.request(URL_SEARCH_FOOD, method: .get, parameters: params, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        handler(false, RequestError(localizedDescription: ERROR_MSG_SEARCH_FAILED))
                        return
                    }
                    
                    if let jsonArr = try JSON(data: data).array {
                        self.foods = [] //clear before
                        for item in jsonArr {
                            let food = Food(json: item)
                            self.foods.append(food)
                        }
                        
                        handler(true, nil)
                    }
                } catch let error {
                    handler(false, error)
                }
                
            case .failure(let error):
                handler(false, error)
            }
        }
    }
}
