//
//  RationServiceNetworkExtension.swift
//  Eatho
//
//  Created by Серафима Зыкова on 04/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension RationService {
    
    func get(handler: @escaping CompletionHandler, dataHandler: @escaping (_: JSON) -> ()) {
        let query: [String : Any] = [
            "token": AuthService.instance.token,
            "count": 10
        ]
        
        Alamofire.request(URL_RATION, method: .get, parameters: query, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                self.resetData()
                
                if let data = response.data {
                    guard let json = JSON(data).array else {
                        handler(false, nil)
                        return
                    }
                    
                    for item in json {
                        dataHandler(item)
                    }
                    
                    handler(true, nil)
                }
            case .failure(let err):
                debugPrint(err)
                handler(false, err)
            }
        }
    }
    
    func update(ration: Ration, handler: @escaping CompletionHandler) {
        let body: JSON = [
            "token": AuthService.instance.token,
            "ration": ration.toJson()
        ]
        
        Alamofire.request(URL_RATION, method: .put, parameters: body.dictionaryObject, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                handler(true, nil)
            case .failure(let err):
                handler(false, err)
            }
        }
    }
    
    func prepRequest(days: Int, handler: @escaping CompletionHandler, dataHandler: @escaping (_: JSON) -> ()) {
        let body: [String : Any] = [
            "token": AuthService.instance.token,
            "count": days
        ]
        
        Alamofire.request(URL_RATION, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data, let json = try JSON(data: data).array else {
                        handler(false, nil)
                        return
                    }
                    
                    for item in json {
                        dataHandler(item)
                    }
                    
                    handler(true, nil)
                } catch let err {
                    handler(false, err)
                }
            case .failure(let err):
                handler(false, err)
            }
        }
    }
    
    func delete(date: String, completion: @escaping CompletionHandler) {
        let body = [
            "token": AuthService.instance.token,
            "date": date
        ]
        
        Alamofire.request(URL_RATION, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                completion(true, nil)
            case .failure(let err):
                completion(false, err)
            }
        }
    }
}
