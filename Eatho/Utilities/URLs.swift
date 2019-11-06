//
//  URLs.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

let URL_BASE = "http://127.0.0.1:3001"
let URL_API = "http://127.0.0.1:3001/api"

let URL_REGISTER = "\(URL_BASE)/auth/register"
let URL_CHECK_EMAIL = "\(URL_BASE)/auth/emailCheck"
let URL_RESET_PASSWORD_INIT = "\(URL_BASE)/auth/resetPassword/init"
let URL_RESET_PASSWORD_CODE = "\(URL_BASE)/auth/resetPassword/code"
let URL_RESET_PASSWORD = "\(URL_BASE)/auth/resetPassword"
let URL_LOGIN = "\(URL_BASE)/auth/login"
let URL_TOKEN = "\(URL_BASE)/auth/token"

let URL_AVAILABLE = "\(URL_API)/available"

let URL_ADD_FOOD = "\(URL_API)/food/add"
let URL_SEARCH_FOOD = "\(URL_API)/food/search"

let URL_RATION = "\(URL_API)/ration"

let URL_SETTINGS = "\(URL_API)/settings"
let URL_USER_DATA = "\(URL_API)/settings/userData"

let URL_SHOPPING_LIST_GET = "\(URL_API)/shoppingList"
let URL_SHOPPING_LIST_UPD = "\(URL_API)/shoppingList/update"
