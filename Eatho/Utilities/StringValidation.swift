//
//  StringValidation.swift
//  Eatho
//
//  Created by Серафима Зыкова on 02/11/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

class StringValidation {
    
    static func isEmail(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: string)
    }
}
