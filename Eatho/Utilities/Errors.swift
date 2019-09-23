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
    let message: String
}

struct ParsingError: Error {
    let data: String
}

struct LocalDataError: Error {
    let errDesc: String
    let failedIndex: Int?
}

// Error messages
let ERROR_MSG_NETWORK_UNREACHABLE = "Sorry! App cannot get your data without internet connection 😢. \nPlease try again later 💜"
let ERROR_MSG_FOOD_CREATION_FAILED = "Food creation error"
let ERROR_MSG_FOOD_GET_FAILED = "Failed to get food list"


// Debug errors
let ERROR_MSG_EMPTY_RESPONSE = "Empty server response"
let ERROR_MSG_FAILED_JSON_ENCODE = "Failed data encoding"
