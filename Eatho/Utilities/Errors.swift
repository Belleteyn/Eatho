//
//  Errors.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

struct InvalidResponse {
    let localizedDescription: String
}

struct ResponseError {
    let code: Int
    let message: String
}

enum AuthError: Error {
    case login, password, keychain
}

enum DataParseError: Error {
    case corruptedData
}

struct RequestError: Error {
    let localizedDescription: String
}

struct ParsingError: Error {
    let data: String
}

struct LocalDataError: Error {
    let localizedDescription: String
}

// Error messages

/*
 - Error message has to be clear - user should know what HE DID WRONG and how he can fix that (but don't blame him)
 - Short and meaningful, Avoid using redundant words
 - Do not confuse user with termins - little stupid humans afraid of them
 - Positive clue
    ✅ DO smth to get result
    ❌ YOU DID IT WRONG
 
 A good error message has three parts: problem identification, cause details if helpful, and a solution if possible.
 
 If text is long, use disclosure
 
 
  ‼️ WARNING ‼️ don't forget to update localization if error messages were changed
 
 */

/* Common errors */
let ERROR_TITLE_NETWORK_UNREACHABLE = "Connection lost"
let ERROR_MSG_NETWORK_UNREACHABLE = "Sorry! App cannot get your data without internet connection. \nPlease try again later 💜"

let ERROR_TITLE_REFRESH_FAILED = NSLocalizedString("Refresh failed", comment: "Common errors")
let ERROR_TITLE_REMOVE_FAILED = NSLocalizedString("Remove failed", comment: "Common errors")
let ERROR_TITLE_UPDATE_FAILED = NSLocalizedString("Update failed", comment: "Common errors")

let ERROR_MSG_INVALID_INDEX = NSLocalizedString("Invalid index", comment: "Common errors")

/* Auth errors */
let ERROR_TITLE_AUTH = NSLocalizedString("Authorization error", comment: "Auth errors")
let ERROR_MSG_KEYCHAIN = NSLocalizedString("Cannot save credentials in keychain", comment: "Auth errors")
let ERROR_MSG_LOG_PASS_INVALID = NSLocalizedString("Login and password combination is invalid", comment: "Auth errors")
let ERROR_MSG_ALREADY_REGISTERED = NSLocalizedString("Sorry, we're unable to register this email", comment: "Auth errors")
let ERROR_MSG_REGISTRATION_UNKNOWN_ERROR = NSLocalizedString("We don't know what could be wrong, but it was 😯", comment: "Auth errors")

/* Available errors */
let ERROR_MSG_FOOD_CREATION_FAILED = "Food creation error"
let ERROR_MSG_FOOD_GET_FAILED = "Failed to get food list"
let ERROR_TITLE_SEARCH_FAILED = "Food search failed"

let ERROR_TITLE_CREATION_DATA_MISSED = "Please enter data"
let ERROR_MSG_CREATION_DATA_MISSED = "All required fields must be filled"

let ERROR_RATION_INVALID_INDEX = "Unable to remove item: no ration selected"

let ERROR_TITLE_SHOPPING_LIST_REQUEST_FAILED = "Shopping list fetching failed"
let ERROR_TITLE_SHOPPING_LIST_UPDATE_FAILED = "Shopping list fetching failed"
let ERROR_TITLE_DIARY_REQUEST_FAILED = "Diary request failed"
let ERROR_TITLE_DIARY_PREP_FAILED = "Diary preparation request failed"

// Debug errors
let ERROR_MSG_INVALID_RESPONSE = "Invalid server response"
let ERROR_MSG_FAILED_JSON_ENCODE = "Failed data encoding"
