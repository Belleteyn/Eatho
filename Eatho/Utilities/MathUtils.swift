//
//  MathUtils.swift
//  Eatho
//
//  Created by Серафима Зыкова on 03/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

func truncateDoubleTail(_ x: Double) -> Double {
    return (round(x * 10) / 10)
}

