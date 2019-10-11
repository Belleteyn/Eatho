//
//  UserNutritionChartView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit
import Charts

class UserNutritionChartView: PieChartView {
    
    var nutrition: UserNutrition?
    
    func initData(nutrition: UserNutrition?) {
        self.nutrition = nutrition
        renderChart()
    }
    
    func renderChart() {
        var dataSet: PieChartDataSet
        
        if let nutrition = self.nutrition {
            let proteins = nutrition.proteins["percent"] ?? 0
            let carbs = nutrition.carbs["percent"] ?? 0
            let fats = nutrition.fats["percent"] ?? 0
            
            
            let entryProteins = PieChartDataEntry(value: proteins, label: "\(PROTEINS)")
            let entryCarbs = PieChartDataEntry(value: carbs, label: "\(CARBS)")
            let entryFats = PieChartDataEntry(value: fats, label: "\(FATS)")
            
            dataSet = PieChartDataSet(entries: [entryProteins, entryCarbs, entryFats], label: "\(round(nutrition.calories * 10) / 10) \(KCAL)")
            dataSet.colors = [EATHO_LIGHT_PURPLE, EATHO_YELLOW, EATHO_RED]
        } else {
            dataSet = PieChartDataSet(entries: nil, label: nil)
        }
        
        dataSet.sliceSpace = 1
        
        let data = PieChartData(dataSet: dataSet)
        self.data = data
        
        //All other additions to this function will go here
        self.holeRadiusPercent = 0.2
        self.holeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.transparentCircleRadiusPercent = 0.4
        
        self.centerAttributedText = NSAttributedString(string: "%", attributes: [NSAttributedString.Key.foregroundColor : TEXT_COLOR])
        
        self.legend.form = .none
        self.legend.textColor = UIColor.clear
        
        self.data?.setValueTextColor(UIColor.white)
        
        //This must stay at end of function
        self.notifyDataSetChanged()
    }
}

