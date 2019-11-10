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

    var nutrition: OverallNutrition?
    var userNutrition: UserNutrition?
    
    func initData(nutrition: OverallNutrition, userNutrition: UserNutrition) {
        self.nutrition = nutrition
        self.userNutrition = userNutrition
        
        renderChart()
    }
    
    func renderChart() {
        guard let nutrition = self.nutrition, let userNutrition = self.userNutrition else { return }
        
        let p = truncateDoubleTail(nutrition.proteins * 4.1), c = truncateDoubleTail(nutrition.carbs * 4.1), f = truncateDoubleTail(nutrition.fats * 9.29), kcal = truncateDoubleTail(nutrition.calories)
        let pg = truncateDoubleTail(nutrition.proteins), cg = truncateDoubleTail(nutrition.carbs), fg = truncateDoubleTail(nutrition.fats)
        
        let up = truncateDoubleTail(userNutrition.proteins.kcal), uc = truncateDoubleTail(userNutrition.carbs.kcal), uf = truncateDoubleTail(userNutrition.fats.kcal), ukcal = truncateDoubleTail(userNutrition.calories)
        let upg = truncateDoubleTail(userNutrition.proteins.g), ucg = truncateDoubleTail(userNutrition.carbs.g), ufg = truncateDoubleTail(userNutrition.fats.g)
        
        let pUnderDiff = up > p ? up - p : 0
        let cUnderDiff = uc > c ? uc - c : 0
        let fUnderDiff = uf > f ? uf - f : 0
        let kcalUnderDiff = userNutrition.calories > nutrition.calories ? ukcal - kcal : 0
        
        let pOverDiff = up < p ? p - up : 0
        let cOverDiff = uc < c ? c - uc : 0
        let fOverDiff = uf < f ? f - uf : 0
        let kcalOverDiff = userNutrition.calories < nutrition.calories ? kcal - ukcal : 0

        let dataSet = [
            BarChartDataSet(entries: [BarChartDataEntry(x: 0.0, yValues: [p, pUnderDiff, pOverDiff])], label: "\(PROTEINS): \(pg) \(OF) \(upg) \(G)"),
            BarChartDataSet(entries: [BarChartDataEntry(x: 1.0, yValues: [c, cUnderDiff, cOverDiff])], label: "\(CARBS): \(cg) \(OF) \(ucg) \(G)"),
            BarChartDataSet(entries: [BarChartDataEntry(x: 2.0, yValues: [f, fUnderDiff, fOverDiff])], label: "\(FATS): \(fg) \(OF) \(ufg) \(G)"),
            BarChartDataSet(entries: [BarChartDataEntry(x: 3.0, yValues: [nutrition.calories, kcalUnderDiff, kcalOverDiff])], label: "\(CALORIES): \(kcal) \(OF) \(ukcal)")
        ]
        
        dataSet[0].colors = [EATHO_PROTEINS, EATHO_PROTEINS_LIGHT, EATHO_PROTEINS_DARK]
        dataSet[1].colors = [EATHO_CARBS, EATHO_CARBS_LIGHT, EATHO_CARBS_DARK]
        dataSet[2].colors = [EATHO_FATS, EATHO_FATS_LIGHT, EATHO_FATS_DARK]
        dataSet[3].colors = [EATHO_MAIN_COLOR, EATHO_MAIN_COLOR_OPACITY50, EATHO_MAIN_COLOR_DARK]

        let data = BarChartData(dataSets: dataSet)
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        self.data = data
        
        //All other additions to this function will go here
        self.legend.horizontalAlignment = .right
        self.legend.verticalAlignment = .center
        self.legend.orientation = .vertical
        self.legend.font = NSUIFont(descriptor: UIFont.systemFont(ofSize: 14).fontDescriptor, size: 14)
        self.legend.textColor = TEXT_COLOR
        
        self.data?.setValueTextColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
        
        self.tintColor = TEXT_COLOR
        
        self.leftAxis.enabled = false
        self.rightAxis.enabled = false
        self.xAxis.enabled = false
        self.drawBarShadowEnabled = false
        
        //This must stay at end of function
        self.notifyDataSetChanged()
    }
}
