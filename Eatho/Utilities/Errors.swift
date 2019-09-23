//
//  Errors.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

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
let ERROR_MSG_NETWORK_UNREACHABLE = "Sorry! App cannot get your data without internet connection 😢. \nPlease try again later 💜"
let ERROR_MSG_FOOD_CREATION_FAILED = "Food creation error"
let ERROR_MSG_FOOD_GET_FAILED = "Failed to get food list"
let ERROR_MSG_SEARCH_FAILED = "Food search failed"

let ERROR_TITLE_SEARCH_FAILED = "Food search failed"
let ERROR_TITLE_SHOPPING_LIST_REQUEST_FAILED = "Shopping list fetching failed"
let ERROR_TITLE_SHOPPING_LIST_UPDATE_FAILED = "Shopping list fetching failed"

// Debug errors
let ERROR_MSG_EMPTY_RESPONSE = "Empty server response"
let ERROR_MSG_FAILED_JSON_ENCODE = "Failed data encoding"
