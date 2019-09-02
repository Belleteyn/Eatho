//
//  RationChartView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 02/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit
import Charts

class RationChartView: BarChartView {

    var nutrition: Nutrition?
    var userNutrition: UserNutrition?
    
    func initData(nutrition: Nutrition, userNutrition: UserNutrition) {
        self.nutrition = nutrition
        self.userNutrition = userNutrition
        
        renderChart()
    }
    
    func renderChart() {
        guard let nutrition = self.nutrition, let userNutrition = self.userNutrition else { return }
        
        let p = nutrition.proteins * 4.1, c = nutrition.carbs * 4.1, f = nutrition.fats * 9.29
        let pUnderDiff = userNutrition.proteins["kcal"]! > p ? userNutrition.proteins["kcal"]! - p : 0
        let cUnderDiff = userNutrition.carbs["kcal"]! > c ? userNutrition.carbs["kcal"]! - c : 0
        let fUnderDiff = userNutrition.fats["kcal"]! > f ? userNutrition.fats["kcal"]! - f : 0
        
        let pOverDiff = userNutrition.proteins["kcal"]! < p ? p - userNutrition.proteins["kcal"]! : 0
        let cOverDiff = userNutrition.carbs["kcal"]! < c ? c - userNutrition.carbs["kcal"]! : 0
        let fOverDiff = userNutrition.fats["kcal"]! < f ? f - userNutrition.fats["kcal"]! : 0
        
        let vals = [
            BarChartDataEntry(x: 0.0, yValues: [p, pUnderDiff, pOverDiff]),
            BarChartDataEntry(x: 1.0, yValues: [c, cUnderDiff, cOverDiff]),
            BarChartDataEntry(x: 2.0, yValues: [f, fUnderDiff, fOverDiff])
        ]
        
        let dataSet = BarChartDataSet(entries: vals, label: "Ration nutrition")
        dataSet.colors = [
            EATHO_LIGHT_PURPLE, EATHO_LIGHT_PURPLE_OPACITY50, EATHO_LIGHT_PURPLE_DARK,
            EATHO_YELLOW, EATHO_YELLOW_OPACITY50, EATHO_YELLOW_DARK,
            EATHO_RED, EATHO_RED_OPACITY50, EATHO_RED_DARK
        ]
        dataSet.stackLabels = ["Ration value", "Under value", "Over value"]
        
        let data = BarChartData(dataSet: dataSet)
        self.data = data
        
        //All other additions to this function will go here
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.legend.horizontalAlignment = .right
        self.legend.verticalAlignment = .center
        self.legend.orientation = .vertical
        self.legend.font = NSUIFont(name: "Avenir", size: 14)!
        self.legend.textColor = TEXT_COLOR
        
        self.data?.setValueTextColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
        self.tintColor = TEXT_COLOR
        
        self.leftAxis.enabled = false
        self.rightAxis.enabled = false
        self.xAxis.enabled = false
        self.drawBarShadowEnabled = false
        
        //This must stay at end of function
        self.notifyDataSetChanged()
    }
}
