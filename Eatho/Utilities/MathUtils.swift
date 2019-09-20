//
//  MathUtils.swift
//  Eatho
//
//  Created by Серафима Зыкова on 03/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

func truncateDoubleTail(_ x: Double) -> Double {
    return (round(x * 100) / 100)
}

func convertMetrics(kg x: Double) -> Double {
    //1 pound = 0.45359237 kg
    return x / 0.45359237
}

func convertMetrics(g x: Double) -> Double {
    //1 pound = 453.59237 g
    return x / 453.59237
}

func convertMetrics(lbs x: Double) -> Double {
    return x * 453.59237
}

func kcalPerLb(kcalPerG: Double) -> Double {
    return kcalPerG / 100 * 453.59237
}
