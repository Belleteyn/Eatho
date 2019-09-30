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
    
    func requestToken(email: String, password: String, handler: @escaping RequestCompletion) {
        let params: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Network.get(url: URL_LOGIN, query: params) { (response, error) in
            handler(response, error)
        }
    }
    
    func invalidateToken(email: String, password: String, handler: @escaping RequestCompletion) {
        let params: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Network.delete(url: URL_TOKEN, query: params) { (response, error) in
            handler(response, error)
        }
    }
    
    func checkEmailToRegistration(email: String, handler: @escaping RequestCompletion) {
        let query: [String : Any] = [ "email": email ]
        
        Network.get(url: URL_CHECK_EMAIL, query: query) { (response, error) in
            handler(response, error)
        }
    }
    
    func registrationRequest(email: String, password: String, handler: @escaping RequestCompletion) {
        let body: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Network.post(url: URL_REGISTER, body: body) { (response, error) in
            handler(response, error)
        }
    }
}
