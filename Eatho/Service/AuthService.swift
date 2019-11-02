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

typealias CompletionHandler = (_ success: Bool, _ error: Error? ) -> ()

class AuthService {
    static let instance = AuthService()
    
    var token: String?
    private(set) var email: String?
    private var password: String?
    
    var credentials: JSON {
        get {
            return [
                "email": AuthService.instance.email ?? "",
                "token": AuthService.instance.token ?? ""
            ]
        }
    }
    
    private func readKeychain() {
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        let keys = keychain.allKeys()
        
        if !keys.isEmpty {
            self.email = keys[0]
            self.password = keychain[email!]
        }
    }
    
    private func writeKeychain(email: String, password: String?) {
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        keychain[email] = password
        
        self.email = email
        self.password = password
    }
    
    func login(completion: @escaping CompletionHandler) {
        readKeychain()
        
        guard let email = email, let password = password else {
            completion(false, AuthError.login)
            return
        }
        
        requestToken(email: email, password: password) { (response, error) in
            if let response = response {
                self.updateLocalToken(result: response.result)
                NotificationCenter.default.post(name: NOTIF_LOGGED_IN, object: nil)
                completion(true, nil)
                return
            }
            
            if let error = error {
                switch error.code {
                case 1:
                    completion(false, AuthError.login)
                case 2:
                    completion(false, AuthError.password)
                default:
                    completion(false, error as? Error)
                }
            }
        }
    }
    
    func login(email: String, password: String, handler: @escaping CompletionHandler) {
        requestToken(email: email, password: password) { (response, error) in
            if let response = response {
                self.updateLocalToken(result: response.result)
                self.writeKeychain(email: email, password: password)
                NotificationCenter.default.post(name: NOTIF_LOGGED_IN, object: nil)
                handler(true, nil)
                return
            }
            
            if let error = error {
                switch error.code {
                case 1:
                    handler(false, AuthError.login)
                case 2:
                    handler(false, AuthError.password)
                default:
                    handler(false, error as? Error)
                }
            }
        }
    }
    
    func invalidateToken() {
        guard let email = email else { return }
        guard let password = password else { return }
        
        // invalidate token on server
        invalidateToken(email: email, password: password) { (_, _) in
            //todo: on error try again?
        }
        
        NotificationCenter.default.post(name: NOTIF_LOGGED_OUT, object: nil)
        self.token = nil
    }
    
    func logOut() {
        invalidateToken()
        
        guard let email = email else { return }
        
        // remove password from keychain
        writeKeychain(email: email, password: nil)
        self.email = nil //password was reset on writing keychain
        
        NotificationCenter.default.post(name: NOTIF_SIGNED_OUT, object: nil)
    }
    
    func register(email: String, password: String, handler: @escaping CompletionHandler) {
        registrationRequest(email: email, password: password) { (response, error) in
            if response != nil {
                self.login(email: email, password: password, handler: handler)
            } else {
                handler(false, error as? Error)
            }
        }
    }
    
    func updateLocalToken(result: Result<Any>) {
        if let json = result.value as? Dictionary<String, Any> {
            if let receivedToken = json["token"] as? String {
                self.token = receivedToken
            }
        }
    }
}
