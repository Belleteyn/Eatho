//
//  Network.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias RequestCompletion = (_ response: DataResponse<Any>?, _ error: ResponseError?) -> ()

class Network {
    
    static func get(url: URLConvertible, query: Parameters?, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: .get, parameters: query, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(response, nil)
            case .failure(let error):
                completion(nil, self.parseError(response: response, error: error))
            }
        }
    }
    
    static func post(url: URLConvertible, body: Parameters?, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(response, nil)
            case .failure(let error):
                completion(nil, self.parseError(response: response, error: error))
            }
        }
    }
    
    static func put(url: URLConvertible, body: Parameters?, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(response, nil)
            case .failure(let error):
                completion(nil, self.parseError(response: response, error: error))
            }
        }
    }
    
    static func delete(url: URLConvertible, body: Parameters?, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(response, nil)
            case .failure(let error):
                completion(nil, self.parseError(response: response, error: error))
            }
        }
    }
    
    private static func parseError(response: DataResponse<Any>, error: Error) -> ResponseError {
        if let data = response.data {
            do {
                let errJson = try JSON(data: data)
                
                let message = errJson["error"].string ?? ""
                
                if let code = errJson["code"].int {
                    let err = ResponseError(code: code, message: message)
                    return err
                } else if let code = response.response?.statusCode {
                    return ResponseError(code: code, message: message)
                }
            } catch {}
        }
        
        return ResponseError(code: -1, message: error.localizedDescription)
    }
}
