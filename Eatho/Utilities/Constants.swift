//
//  Constants.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import UIKit

// Type
typealias CompletionHandler = (_ success: Bool, _ error: Error? ) -> ()
typealias DataCompletionHandler = (_ food: FoodItem?) -> ()

// Keychain
let KEYCHAIN_SERVICE = "EathoService"

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
let NOTIF_USER_DATA_SYNC_ERROR = Notification.Name("userDataSyncError")

let NOTIF_SEARCH_FOOD_ADD = Notification.Name("searchFoodAdd")
let NOTIF_SEARCH_FOOD_ADD_DONE = Notification.Name("searchFoodAddDone")

let NOTIF_DIARY_OPEN = Notification.Name("openDiary")

// headers
let JSON_HEADER: [String : String] = ["Content-Type": "application/json; charset=utf-8"]

// segues
let TO_LOGIN_SEGUE = "toLoginSegue"
let TO_REGISTER_SEGUE = "toRegisterSegue"
let TO_PWD_RECOVERY_SEGUE = "toPwdRecoverySegue"
let TO_AVAILABLE_SEGUE = "toAvailableSegue"
let TO_REG_PASSWORD = "toRegPasswordSegue"
let UNWIND_TO_WELCOME = "unwindToWelcome"

// localized common strings
let G = NSLocalizedString("g", comment: "Food")
let KCAL = NSLocalizedString("kcal", comment: "Food")
let LB = NSLocalizedString("lb", comment: "Food")
let PROTEINS = NSLocalizedString("Proteins", comment: "Food")
let CARBS = NSLocalizedString("Carbs", comment: "Food")
let FATS = NSLocalizedString("Fats", comment: "Food")
let CALORIES = NSLocalizedString("Calories", comment: "Food")
let OF = NSLocalizedString("of", comment: "")

// localized swipe actions
let REMOVE = NSLocalizedString("Remove", comment: "Actions")
let UPDATE = NSLocalizedString("Update", comment: "Actions")
let DETAILS = NSLocalizedString("Details", comment: "Actions")

// system images

@available(iOS 13.0, *)
let REMOVE_IMG = UIImage(systemName: "trash.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold))
@available(iOS 13.0, *)
let INFO_IMG = UIImage(systemName: "info.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold))
@available(iOS 13.0, *)
let UPDATE_IMG = UIImage(systemName: "pencil.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold))
