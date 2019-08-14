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
typealias DataCompletionHandler = (_ food: FoodItem?) -> ()

// URLs
let URL_BASE = "http://127.0.0.1:3001"
let URL_API = "http://127.0.0.1:3001/api"

let URL_REGISTER = "\(URL_BASE)/auth/register"
let URL_LOGIN = "\(URL_BASE)/auth/login"

let URL_AVAILABLE = "\(URL_API)/available"

let URL_ADD_FOOD = "\(URL_API)/food/add"

let URL_RATION = "\(URL_API)/ration"
let URL_UPD_RATION = "\(URL_API)/ration/update"

let URL_SETTINGS = "\(URL_API)/settings"
let URL_USER_DATA = "\(URL_API)/settings/userData"

let URL_SHOPPING_LIST_GET = "\(URL_API)/shoppingList"
let URL_SHOPPING_LIST_UPD = "\(URL_API)/shoppingList/update"

// user defaults
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_LOGIN_EMAIL = "userLoginEmail"
let IS_CONFIGURED = "settingsConfigured"
let USER_INFO = "eathoUserInfo"

// notifications
let NOTIF_AUTH_DATA_CHANGED = Notification.Name(rawValue: "authDataChanged")
let NOTIF_USER_DATA_CHANGED = Notification.Name(rawValue: "userDataChanged")
let NOTIF_FOOD_DATA_CHANGED = Notification.Name("foodDataChanged")
let NOTIF_RATION_DATA_CHANGED = Notification.Name("rationDataChanged")
let NOTIF_SHOPPING_LIST_DATA_CHAGNED = Notification.Name("shoppingListDataChanged")

let NOTIF_USER_ACTIVITY_LEVEL_CHANGED = Notification.Name("userActivityLevelChanged")

// headers
let JSON_HEADER: [String : String] = ["Content-Type": "application/json; charset=utf-8"]

// segues
let TO_LOGIN_SEGUE = "toLoginSegue"
let TO_REGISTER_SEGUE = "toRegisterSegue"
let TO_AVAILABLE_SEGUE = "toAvailableSegue"
let UNWIND_TO_WELCOME = "unwindToWelcome"

//  colors
let LOGIN_PLACEHOLDER_COLOR = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.604291524)
let TEXT_COLOR = #colorLiteral(red: 0.3698856235, green: 0.4013975859, blue: 0.4641202092, alpha: 1)
let LIGHT_TEXT_COLOR = #colorLiteral(red: 0.6431372549, green: 0.6784313725, blue: 0.7529411765, alpha: 1)
let EATHO_RED = #colorLiteral(red: 0.9921568627, green: 0.4705882353, blue: 0.4666666667, alpha: 1)
let EATHO_YELLOW = #colorLiteral(red: 0.9764705882, green: 0.7058823529, blue: 0.4392156863, alpha: 1)
let EATHO_LIGHT_PURPLE = #colorLiteral(red: 0.6758870114, green: 0.6235294118, blue: 0.9882352941, alpha: 1)
