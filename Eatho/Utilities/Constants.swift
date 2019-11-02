//
//  Constants.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import UIKit

// Keychain
let KEYCHAIN_SERVICE = "EathoService"

// user defaults
let USER_INFO = "eathoUserInfo"

// notifications
let NOTIF_LOGGED_IN = Notification.Name("loggedIn")
let NOTIF_LOGGED_OUT = Notification.Name("loggedOut")
let NOTIF_SIGNED_OUT = Notification.Name("signedOut")

let NOTIF_USER_DATA_CHANGED = Notification.Name(rawValue: "userDataChanged")
let NOTIF_FOOD_DATA_CHANGED = Notification.Name("foodDataChanged")
let NOTIF_RATION_DATA_CHANGED = Notification.Name("rationDataChanged")
let NOTIF_SHOPPING_LIST_DATA_CHAGNED = Notification.Name("shoppingListDataChanged")

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
let TO_PASSWORD_REGISTRATION_SEGUE = "toPasswordRegisterSegue"
let TO_PWD_RESET_SEGUE = "toPwdRecoverySegue"
let TO_PWD_RESET_CODE_SEGUE = "toCodeInputPassResetSegue"
let TO_PWD_SET_SEGUE = "toNewPasswordSegue"
let TO_AVAILABLE_SEGUE = "toAvailableSegue"
let TO_REG_PASSWORD = "toRegPasswordSegue"
let UNWIND_TO_WELCOME = "unwindToWelcome"

// localized common strings
let G = NSLocalizedString("g", comment: "Food")
let KCAL = NSLocalizedString("kcal", comment: "Food")
let LB = NSLocalizedString("lb", comment: "Food")
let OF = NSLocalizedString("of", comment: "")

// localized food and nutrient strings
let PROTEINS = NSLocalizedString("Proteins", comment: "Food")
let CARBS = NSLocalizedString("Carbs", comment: "Food")
let FATS = NSLocalizedString("Fats", comment: "Food")
let CALORIES = NSLocalizedString("Calories", comment: "Food")
let FROM_FAT = NSLocalizedString("from fat", comment: "Food")
let FIBER = NSLocalizedString("dietary fiber", comment: "Food")
let SUGARS = NSLocalizedString("sugars", comment: "Food")
let TRANS_FATS = NSLocalizedString("trans", comment: "Food")
let SATURATED = NSLocalizedString("saturated", comment: "Food")
let MONO = NSLocalizedString("monounsaturated", comment: "Food")
let POLY = NSLocalizedString("polyunsaturated", comment: "Food")
let GI = NSLocalizedString("Glycemic index", comment: "Food")
let NUTRITION_FACTS = NSLocalizedString("Nutrition facts", comment: "Food")

let PER100G = NSLocalizedString("per 100g", comment: "Food")

//diary
let DAYS = NSLocalizedString("days", comment: "Diary")
let PREPARE = NSLocalizedString("prepare", comment: "Diary")

// user portion data
let AVAILABLE = NSLocalizedString("Available", comment: "Food")
let MIN = NSLocalizedString("Minimal portion", comment: "Food")
let MAX = NSLocalizedString("Maximal portion", comment: "Food")
let DELTA = NSLocalizedString("Delta portion", comment: "Food")

// localized swipe actions
let REMOVE = NSLocalizedString("Remove", comment: "Actions")
let UPDATE = NSLocalizedString("Update", comment: "Actions")
let DETAILS = NSLocalizedString("Details", comment: "Actions")

//
let NUTRITION_WARNING_TEXT = "Please, note that all formulas for calories and nutrients calculation are not perfect and may not conform to your body or your goals.".localized
let NUTRITION_CONSULT_TITLE = "Consult with your doctor or your fitness trainer".localized
let NUTRITION_CONSULT_TEXT = "to get optimal nutrients in your daily ingestions".localized
let NUTRITION_CORRECT_TITLE = "Correct values".localized
let NUTRITION_CORRECT_TEXT = "if you feel overwhelmed or hungry".localized
let NUTRITION_NEEDS_TITLE = "Correct ration".localized
let NUTRITION_NEEDS_TEXT = "Remember that every body is individual and it's needs can vary due to outside parameters".localized

let PASSWORD_RESET_INFO_TEXT = "We sent confirmation code on entered email. Please enter it here. If you didn't receive code in 20 seconds, feel free to contact us to get help".localized

// system images

@available(iOS 13.0, *)
let REMOVE_IMG = UIImage(systemName: "trash.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold))
@available(iOS 13.0, *)
let INFO_IMG = UIImage(systemName: "info.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold))
@available(iOS 13.0, *)
let UPDATE_IMG = UIImage(systemName: "pencil.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold))


// fonts for
let SmallScreenSmallFont = UIFont.systemFont(ofSize: 11)
let SmallScreenMediumFont = UIFont.systemFont(ofSize: 13)
let SmallScreenBigFont = UIFont.systemFont(ofSize: 15)

let SCREEN_WIDTH_LIMIT: CGFloat = 380

var SMALL_FONT: UIFont {
    get {
        if UIScreen.main.bounds.width < SCREEN_WIDTH_LIMIT {
            return UIFont.systemFont(ofSize: 11)
        } else {
            return UIFont.systemFont(ofSize: 13)
        }
    }
}

var MEDIUM_FONT: UIFont {
    get {
        if UIScreen.main.bounds.width < SCREEN_WIDTH_LIMIT {
            return UIFont.systemFont(ofSize: 13)
        } else {
            return UIFont.systemFont(ofSize: 15)
        }
    }
}

var BIG_FONT: UIFont {
    get {
        if UIScreen.main.bounds.width < SCREEN_WIDTH_LIMIT {
            return UIFont.systemFont(ofSize: 15)
        } else {
            return UIFont.systemFont(ofSize: 17)
        }
    }
}
