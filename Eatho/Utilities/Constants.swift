//
//  Constants.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (_ success: Bool, _ error: Error? ) -> ()
typealias DataCompletionHandler = (_ food: FoodItem?) -> ()

// URLs
let URL_BASE = "http://127.0.0.1:3001"
let URL_API = "http://127.0.0.1:3001/api"

let URL_REGISTER = "\(URL_BASE)/auth/register"
let URL_LOGIN = "\(URL_BASE)/auth/login"

let URL_AVAILABLE = "\(URL_API)/available"

let URL_ADD_FOOD = "\(URL_API)/food/add"
let URL_SEARCH_FOOD = "\(URL_API)/food/search"

let URL_RATION = "\(URL_API)/ration"

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
let NOTIF_USER_NUTRITION_CHANGED = Notification.Name("userNutritionChanged")

let NOTIF_SEARCH_FOOD_ADD = Notification.Name("searchFoodAdd")
let NOTIF_SEARCH_FOOD_ADD_DONE = Notification.Name("searchFoodAddDone")

let NOTIF_DIARY_OPEN = Notification.Name("openDiary")

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
let TEXT_BACKGROUND = #colorLiteral(red: 0.8941176471, green: 0.8980392157, blue: 0.937254902, alpha: 0.53)

let EATHO_MAIN_COLOR = #colorLiteral(red: 0.8352941176, green: 0.6235294118, blue: 0.9882352941, alpha: 1)
let EATHO_MAIN_COLOR_OPACITY50 = #colorLiteral(red: 0.8352941176, green: 0.6235294118, blue: 0.9882352941, alpha: 0.5)
let EATHO_MAIN_COLOR_DARK = #colorLiteral(red: 0.5309668771, green: 0.454708024, blue: 0.7838612052, alpha: 0.8645654966)

let EATHO_RED = #colorLiteral(red: 0.9921568627, green: 0.4705882353, blue: 0.4666666667, alpha: 1)
let EATHO_RED_OPACITY50 = #colorLiteral(red: 0.9921568627, green: 0.4705882353, blue: 0.4666666667, alpha: 0.5)
let EATHO_RED_DARK = #colorLiteral(red: 0.8434460616, green: 0.400053468, blue: 0.3967196891, alpha: 1)
let EATHO_YELLOW = #colorLiteral(red: 0.9386120694, green: 0.6785147489, blue: 0.4221869549, alpha: 1)
let EATHO_YELLOW_OPACITY50 = #colorLiteral(red: 0.9764705882, green: 0.7058823529, blue: 0.4392156863, alpha: 0.5)
let EATHO_YELLOW_DARK = #colorLiteral(red: 0.8470044949, green: 0.6122924059, blue: 0.3809819415, alpha: 1)
let EATHO_PURPLE = #colorLiteral(red: 0.5568627451, green: 0.5490196078, blue: 0.9137254902, alpha: 1)
let EATHO_LIGHT_PURPLE = #colorLiteral(red: 0.6745098039, green: 0.6235294118, blue: 0.9882352941, alpha: 1)
let EATHO_LIGHT_PURPLE_OPACITY50 = #colorLiteral(red: 0.6745098039, green: 0.6235294118, blue: 0.9882352941, alpha: 0.5)
let EATHO_LIGHT_PURPLE_DARK = #colorLiteral(red: 0.4353762117, green: 0.4024698701, blue: 0.6378767753, alpha: 1)

let EATHO_PROTEINS = #colorLiteral(red: 0.6745098039, green: 0.6235294118, blue: 0.9882352941, alpha: 1)
let EATHO_PROTEINS_LIGHT = #colorLiteral(red: 0.6745098039, green: 0.6235294118, blue: 0.9882352941, alpha: 0.5)
let EATHO_PROTEINS_DARK = #colorLiteral(red: 0.4598281837, green: 0.4234303884, blue: 0.7354114921, alpha: 0.7983465325)
let EATHO_CARBS = EATHO_YELLOW
let EATHO_CARBS_LIGHT = EATHO_YELLOW_OPACITY50
let EATHO_CARBS_DARK = #colorLiteral(red: 0.7897848888, green: 0.5032464764, blue: 0.1757740057, alpha: 0.8596157963)
let EATHO_FATS = EATHO_RED
let EATHO_FATS_LIGHT = EATHO_RED_OPACITY50
let EATHO_FATS_DARK = #colorLiteral(red: 0.8037964612, green: 0.375762808, blue: 0.3610030268, alpha: 0.8484589041)
