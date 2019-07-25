//
//  Constants.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ success: Bool) -> ()

//URL
let URL_BASE = "http://localhost:3005"
let URL_REGISTER = "\(URL_BASE)/register"
let URL_LOGIN = "\(URL_BASE)/login"

//user defaults
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_LOGIN_EMAIL = "userLoginEmail"

//headers
let AUTH_HEADER: [String : String] = [:]
