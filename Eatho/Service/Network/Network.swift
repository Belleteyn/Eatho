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
    static let instance = Network()
    
    func get(url: URLConvertible, query: Parameters?, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: .get, parameters: query, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(response, nil)
            case .failure(let error):
                completion(nil, self.parseError(response: response, error: error))
            }
        }
    }
    
    func post(url: URLConvertible, body: Parameters?, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(response, nil)
            case .failure(let error):
                completion(nil, self.parseError(response: response, error: error))
            }
        }
    }
    
    func put(url: URLConvertible, body: Parameters?, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(response, nil)
            case .failure(let error):
                completion(nil, self.parseError(response: response, error: error))
            }
        }
    }
    
    func delete(url: URLConvertible, query: Parameters?, completion: @escaping RequestCompletion) {
        Alamofire.request(url, method: .delete, parameters: query, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(response, nil)
            case .failure(let error):
                completion(nil, self.parseError(response: response, error: error))
            }
        }
    }
    
    private func parseError(response: DataResponse<Any>, error: Error) -> ResponseError {
        if let data = response.data {
            do {
                let errJson = try JSON(data: data)
                
                if let code = errJson["code"].int, let message = errJson["error"].string {
                    let err = ResponseError(code: code, error: message)
                    return err
                }
            } catch {}
        }
        
        return ResponseError(code: -1, error: error.localizedDescription)
    }
}
