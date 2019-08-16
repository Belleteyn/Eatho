//
//  NutritionChartView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 16/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit
import Charts

class NutritionChartView: PieChartView {
    
    var nutritionFacts: NutritionFacts?
    
    func initData(nutrition: NutritionFacts) {
        self.nutritionFacts = nutrition
        renderChart()
    }
    
    func renderChart() {
        guard let nutrition = self.nutritionFacts else { return }
        
        let entryProteins = PieChartDataEntry(value: nutrition.proteins!, label: "Proteins, \(nutrition.proteins!) g")
        let entryCarbs = PieChartDataEntry(value: nutrition.carbs.total!, label: "Carbs, \(nutrition.carbs.total!) g")
        let entryFats = PieChartDataEntry(value: nutrition.fats.total!, label: "Fats, \(nutrition.fats.total!) g")
        let dataSet = PieChartDataSet(entries: [entryProteins, entryCarbs, entryFats], label: "\(nutrition.calories.total!) kcal")
        let data = PieChartData(dataSet: dataSet)
        self.data = data
        
        //All other additions to this function will go here
        dataSet.colors = [EATHO_LIGHT_PURPLE, EATHO_YELLOW, EATHO_RED]
        self.holeRadiusPercent = 0.48
        self.holeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.legend.horizontalAlignment = .right
        self.legend.verticalAlignment = .center
        self.legend.orientation = .vertical
        self.legend.font = NSUIFont(name: "Avenir", size: 14)!
        self.legend.textColor = TEXT_COLOR
        
        self.data?.setValueTextColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        self.centerTextRadiusPercent = 0.5
        self.tintColor = TEXT_COLOR
        
        //This must stay at end of function
        self.notifyDataSetChanged()
    }
}
