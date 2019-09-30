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
    
    func get(completion: @escaping RequestCompletion, dataHandler: @escaping (_: JSON) -> ()) {
        let query: [String : Any] = [
            "email": AuthService.instance.email ?? "",
            "token": AuthService.instance.token ?? "",
            "count": 10
        ]
        
        Network.get(url: URL_RATION, query: query) { (response, error) in
            if let data = response?.data {
                guard let json = JSON(data).array else {
                    completion(nil, ResponseError(code: -1, message: ERROR_MSG_INVALID_RESPONSE))
                    return
                }
                
                for item in json {
                    dataHandler(item)
                }
            }
            
            completion(response, error)
        }
    }
    
    func update(ration: Ration, completion: @escaping RequestCompletion) {
        let body: JSON = [
            "email": AuthService.instance.email ?? "",
            "token": AuthService.instance.token ?? "",
            "ration": ration.toJson()
        ]
        
        Network.put(url: URL_RATION, body: body.dictionaryObject) { (response, error) in
            completion(response, error)
        }
    }
    
    func prepRequest(days: Int, completion: @escaping RequestCompletion, dataHandler: @escaping (_: JSON) -> ()) {
        let body: [String : Any] = [
            "email": AuthService.instance.email ?? "",
            "token": AuthService.instance.token ?? "",
            "prepCount": days,
            "diaryCount": 10
        ]
        
        Network.post(url: URL_RATION, body: body) { (response, error) in
            if let data = response?.data {
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            dataHandler(item)
                        }
                    }
                } catch let err {
                    completion(nil, ResponseError(code: -1, message: "\(ERROR_MSG_INVALID_RESPONSE)\n\(err.localizedDescription)"))
                    return
                }
            }
            
            completion(response, error)
        }
    }
    
    func delete(date: String, completion: @escaping RequestCompletion) {
        let body = [
            "email": AuthService.instance.email ?? "",
            "token": AuthService.instance.token ?? "",
            "date": date
        ]
        
        Network.delete(url: URL_RATION, body: body) { (response, error) in
            completion(response, error)
        }
    }
}
