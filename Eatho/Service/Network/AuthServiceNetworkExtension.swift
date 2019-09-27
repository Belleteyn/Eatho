//
//  AuthServiceNetwirkExtension.swift
//  Eatho
//
//  Created by Серафима Зыкова on 27/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension AuthService {
    
    private func parseErrorCode(response: DataResponse<Any>) -> Int? {
        do {
            if let data = response.data {
                let errJson = try JSON(data: data)
                if let code = errJson["code"].int {
                    return code
                }
            }
        } catch {
            print("response json parsing failed")
        }
        
        return nil
    }
    
    
    func requestToken(email: String, password: String, handler: @escaping CompletionHandler) {
        let params: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .get, parameters: params, encoding: URLEncoding.default, headers: JSON_HEADER).validate().responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                self.updateLocalToken(result: response.result)
                handler(true, nil)
            case .failure(let error):
                if let code = self.parseErrorCode(response: response) {
                    if code == 1 {
                        handler(false, AuthError.login)
                    } else {
                        handler(false, AuthError.password)
                    }
                    
                } else {
                    handler(false, error)
                }
            }
        })
    }
    
    func invalidateToken(email: String, password: String, handler: @escaping CompletionHandler) {
        let params: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(URL_INVALIDATE_TOKEN, method: .delete, parameters: params, encoding: URLEncoding.default).validate().responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                handler(true, nil)
            case .failure(let error):
                handler(false, error)
            }
        })
    }
    
    func loginOnServer(email: String, password: String, handler: @escaping CompletionHandler) {
        let params: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .get, parameters: params, encoding: URLEncoding.default, headers: JSON_HEADER).validate().responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                self.updateLocalToken(result: response.result)
                handler(true, nil)
            case .failure(let error):
                do {
                    if let data = response.data {
                        let errJson = try JSON(data: data)
                        print(errJson)
                        if let code = errJson["code"].int {
                            if code == 1 {
                                handler(false, AuthError.login)
                            } else {
                                handler(false, AuthError.password)
                            }
                            return
                        }
                    }
                } catch {
                    print("login response: json parsing failed")
                }
                
                handler(false, error)
            }
        })
    }
    
    func checkEmailToRegistrationRequest(email: String, handler: @escaping CompletionHandler) {
        let body: [String : Any] = [ "email": email ]
        
        Alamofire.request(URL_CHECK_EMAIL, method: .get, parameters: body, encoding: URLEncoding.default).validate().responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                self.updateLocalToken(result: response.result)
                handler(true, nil)
            case .failure(let error):
                handler(false, error)
            }
        })
    }
    
    func registerOnErver(email: String, password: String, handler: @escaping CompletionHandler) {
        let body: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success:
//                let keychain = Keychain(service: KEYCHAIN_SERVICE)
//                do {
//                    try keychain.set(password, key: KEYCHAIN_SERVICE)
//                } catch let err {
//                    print(err)
//                }
                
                self.updateLocalToken(result: response.result)
                handler(true, nil)
            case .failure(let error):
                handler(false, error)
            }
        })
    }
}
