//
//  AuthService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set {
            let oldValue = defaults.bool(forKey: LOGGED_IN_KEY)
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
            
            if (newValue != oldValue) {
                NotificationCenter.default.post(name: NOTIF_AUTH_DATA_CHANGED, object: nil)
            }
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
            if let email = defaults.string(forKey: USER_LOGIN_EMAIL) {
                return email
            }
            return ""
        }
        
        set {
            defaults.setValue(newValue, forKey: USER_LOGIN_EMAIL)
        }
    }
    
    var credentials: JSON {
        get {
            return [
                "email": AuthService.instance.userEmail,
                "token": AuthService.instance.token
            ]
        }
    }
    
    func register(email: String, password: String, handler: @escaping CompletionHandler) {
        let body: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                self.handleResponse(result: response.result)
                handler(true, nil)
            case .failure(let error):
                handler(false, error)
            }
        })
    }
    
    func checkEmailToRegistration(email: String, handler: @escaping CompletionHandler) {
        let body: [String : Any] = [ "email": email ]
        
        Alamofire.request(URL_CHECK_EMAIL, method: .get, parameters: body, encoding: URLEncoding.default).validate().responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                self.handleResponse(result: response.result)
                handler(true, nil)
            case .failure(let error):
                handler(false, error)
            }
        })
    }
    
    func login(email: String, password: String, handler: @escaping CompletionHandler) {
        let params: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .get, parameters: params, encoding: URLEncoding.default, headers: JSON_HEADER).validate().responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success:
                self.handleResponse(result: response.result)
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
    
    func logOut() {
        self.token = ""
        self.userEmail = ""
        self.isLoggedIn = false
        
        // clear saved data on sign out
        defaults.set(false, forKey: LOGGED_IN_KEY)
        defaults.set(nil, forKey: TOKEN_KEY)
        defaults.set(nil, forKey: USER_LOGIN_EMAIL)
        defaults.set(nil, forKey: IS_CONFIGURED)
        defaults.set(nil, forKey: USER_INFO)
        
        NotificationCenter.default.post(name: NOTIF_AUTH_DATA_CHANGED, object: nil)
    }
    
    private func handleResponse(result: Result<Any>) {
        if let json = result.value as? Dictionary<String, Any> {
            if let receivedToken = json["token"] as? String, let receivedEmail = json["email"] as? String {
                self.token = receivedToken
                self.userEmail = receivedEmail
                self.isLoggedIn = true
            }
        }
    }
}
