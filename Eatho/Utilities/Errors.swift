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
    let error: String
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
 */

let ERROR_TITLE_NETWORK_UNREACHABLE = "Connection lost"
let ERROR_MSG_NETWORK_UNREACHABLE = "Sorry! App cannot get your data without internet connection. \nPlease try again later 💜"

let ERROR_MSG_LOGIN_MISSED = "Please enter email"
let ERROR_MSG_PASSWORD_MISSED = "Please enter password"
let ERROR_MSG_USER_NOT_FOUND = "This email was not registered, please check entered email or register if you didn't"
let ERROR_MSG_ALREADY_REGISTERED = "This email was registered earlier"
let ERROR_MSG_REGISTRATION_FAILED = "I don't know what could be wrong, but it was 😯"
let ERROR_MSG_INCORRECT_PASSWORD = "Password is incorrect, try again! 😉"


let ERROR_MSG_FOOD_CREATION_FAILED = "Food creation error"
let ERROR_MSG_FOOD_GET_FAILED = "Failed to get food list"
let ERROR_MSG_SEARCH_FAILED = "Food search failed"

let ERROR_TITLE_SEARCH_FAILED = "Food search failed"
let ERROR_TITLE_SHOPPING_LIST_REQUEST_FAILED = "Shopping list fetching failed"
let ERROR_TITLE_SHOPPING_LIST_UPDATE_FAILED = "Shopping list fetching failed"
let ERROR_TITLE_DIARY_REQUEST_FAILED = "Diary request failed"
let ERROR_TITLE_DIARY_PREP_FAILED = "Diary preparation request failed"

// Debug errors
let ERROR_MSG_EMPTY_RESPONSE = "Empty server response"
let ERROR_MSG_FAILED_JSON_ENCODE = "Failed data encoding"
