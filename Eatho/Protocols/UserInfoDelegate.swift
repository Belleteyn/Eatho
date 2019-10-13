//
//  UserInfoDelegate.swift
//  Eatho
//
//  Created by Серафима Зыкова on 12/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

protocol UserInfoDelegate {
    var userInfo: UserInfo { get set }
    
    func userInfoChanged(userInfo: UserInfo)
}
