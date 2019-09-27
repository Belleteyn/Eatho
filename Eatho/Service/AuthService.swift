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
import KeychainAccess

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var token: String?
    
    private var email: String?
    private var pwd: String?
    
    var isLoggedIn: Bool {
        get {
            return email != nil && pwd != nil
        }
    }
    
    var userEmail: String {
        get {
            return email ?? ""
        }
        
        set {
            email = newValue
        }
    }
    
    var credentials: JSON {
        get {
            return [
                "token": AuthService.instance.token ?? ""
            ]
        }
    }
    
    init() {
        readKeychain()
    }
    
    private func readKeychain() {
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        let keys = keychain.allKeys()
        
        if !keys.isEmpty {
            let email = keys[0]
            let pwd = keychain[email]
            
            self.email = email
            self.pwd = pwd
        }
        
        print("READ \(email) \(pwd)")
    }
    
    private func writeKeychain(email: String, password: String?) {
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        keychain[email] = password
        
        self.email = email
        self.pwd = password
        
        print("WRITE \(email) \(pwd)")
    }
    
    func login(completion: @escaping CompletionHandler) {
        guard let email = email, let pwd = pwd else {
            completion(false, AuthError.login)
            return
        }
        
        print("DEFAULT LOGIN AS ", email, pwd)
        login(email: email, password: pwd, handler: completion)
    }
    
    func login(email: String, password: String, handler: @escaping CompletionHandler) {
        loginOnServer(email: email, password: password) { (success, error) in
            if error == nil {
                self.writeKeychain(email: email, password: password)
            }
            
            print("token: \(self.token)")
            handler(success, error)
        }
    }
    
    func logOut() {
        guard let email = email else { return }
        guard let pwd = pwd else { return }
        
        // invalidate token on server
        invalidateToken(email: email, password: pwd) { (_, _) in
            //todo: try again?
        }
        
        // remove password from keychain
        writeKeychain(email: email, password: nil)
        
        self.token = nil
        self.email = nil
        self.pwd = nil
        
        // clear saved data on sign out
        defaults.set(nil, forKey: IS_CONFIGURED)
        defaults.set(nil, forKey: USER_INFO)
        
        NotificationCenter.default.post(name: NOTIF_AUTH_DATA_CHANGED, object: nil)
    }
    
    func checkEmailToRegistration(email: String, handler: @escaping CompletionHandler) {
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
    
    func register(email: String, password: String, handler: @escaping CompletionHandler) {
        let body: [String : Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON(completionHandler: {
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
    
    func updateLocalToken(result: Result<Any>) {
        if let json = result.value as? Dictionary<String, Any> {
            if let receivedToken = json["token"] as? String, let receivedEmail = json["email"] as? String {
                self.token = receivedToken
                self.userEmail = receivedEmail
            }
        }
    }
}
