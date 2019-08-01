//
//  Constants.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (_ success: Bool) -> ()

// URLs
let URL_BASE = "http://127.0.0.1:3001"
let URL_API = "http://127.0.0.1:3001/api"

let URL_REGISTER = "\(URL_BASE)/auth/register"
let URL_LOGIN = "\(URL_BASE)/auth/login"

let URL_AVAILABLE = "\(URL_API)/available"
let URL_ADD_AVAILABLE = "\(URL_AVAILABLE)/add"

let URL_ADD_FOOD = "\(URL_API)/food/add"

// user defaults
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_LOGIN_EMAIL = "userLoginEmail"
let IS_CONFIGURED = "settingsConfigured"

// notifications
let NOTIF_USER_DATA_CHANGED = Notification.Name(rawValue: "userDataChanged")
let NOTIF_FOOD_DATA_CHANGED = Notification.Name("foodDataChanged")

let NOTIF_USER_ACTIVITY_LEVEL_CHANGED = Notification.Name("userActivityLevelChanged")

// headers
let AUTH_HEADER: [String : String] = ["Content-Type": "application/json; charset=utf-8"]

// segues
let TO_LOGIN_SEGUE = "toLoginSegue"
let TO_REGISTER_SEGUE = "toRegisterSegue"
let TO_AVAILABLE_SEGUE = "toAvailableSegue"
let UNWIND_TO_WELCOME = "unwindToWelcome"

//  colors
let LOGIN_PLACEHOLDER_COLOR = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.604291524)
let TEXT_COLOR = #colorLiteral(red: 0.3698856235, green: 0.4013975859, blue: 0.4641202092, alpha: 1)
