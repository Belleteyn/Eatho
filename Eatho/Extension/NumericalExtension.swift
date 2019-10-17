//
//  NumericalExtension.swift
//  Eatho
//
//  Created by Серафима Зыкова on 13/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

extension Double {
    func truncated() -> Double {
        var x = self * 10
        x.round()
        return x / 10
    }
}

extension Float {
    func truncated() -> Float {
        var x = self * 10
        x.round()
        return x / 10
    }
}
