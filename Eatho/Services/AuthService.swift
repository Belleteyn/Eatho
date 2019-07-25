//
//  AuthService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var token: String {
        get {
            return defaults.string(forKey: TOKEN_KEY)!
        }
        
        set {
            defaults.setValue(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.string(forKey: USER_LOGIN_EMAIL)!
        }
        
        set {
            defaults.setValue(newValue, forKey: USER_LOGIN_EMAIL)
        }
    }
    
    func register(email: String, password: String, handler: @escaping CompletionHandler) {
        let body: [String : Any] = [
            "email": email,
            "password": password
        ]
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: URLEncoding.default, headers: AUTH_HEADER).responseJSON(completionHandler: {
            (response) in
            if (response.error == nil) {
                self.handleResponse(result: response.result)
                handler(true)
            } else {
                handler(false)
                debugPrint(response.error as Any)
            }
        })
    }
    
    func login(email: String, password: String, handler: @escaping CompletionHandler) {
        let body: [String : Any] = [
            "email": email,
            "password": password
        ]
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: URLEncoding.default, headers: AUTH_HEADER).responseJSON(completionHandler: {
            (response) in
            if (response.error == nil) {
                self.handleResponse(result: response.result)
                handler(true)
            } else {
                handler(false)
                debugPrint(response.error as Any)
            }
        })
    }
    
    private func handleResponse(result: Result<Any>) {
        if let json = result.value as? Dictionary<String, Any> {
            if let receivedToken = json["token"] as? String {
                self.token = receivedToken
            } else {
                return
            }
            
            if let receivedEmail = json["email"] as? String {
                self.userEmail = receivedEmail
            } else {
                return
            }
            
            self.isLoggedIn = true
        }
    }
}
