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
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "count": 10
        ]
        
        Alamofire.request(URL_RATION, method: .get, parameters: query, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                self.resetData()
                
                if let data = response.data {
                    guard let json = JSON(data).array else { handler(false); return }
                    
                    for item in json {
                        dataHandler(item)
                    }
                    
                    handler(true)
                }
            case .failure(let err):
                debugPrint(err)
                handler(false)
            }
        }
    }
    
    func prepRequest(days: Int, handler: @escaping CompletionHandler, dataHandler: @escaping (_: JSON) -> ()) {
        let body: [String : Any] = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token,
            "count": days
        ]
        
        Alamofire.request(URL_RATION, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            
            do {
                guard let data = response.data, let json = try JSON(data: data).array else { handler(false); return }
                
                for item in json {
                    dataHandler(item)
                }
                
                handler(true)
            } catch let err {
                debugPrint(err)
                handler(false)
            }
        }
    }
}
