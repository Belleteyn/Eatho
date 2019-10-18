//
//  SingleValuePieChart.swift
//  Eatho
//
//  Created by Серафима Зыкова on 18/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit
import Charts

class SingleValuePieChart: PieChartView {

    var value: Double = 0
    var color: UIColor = UIColor.gray
    
    /**
     data initialization and chart render
     
     - parameters:
     percentValue: number in range 0..100. if number is greater than 100, overheading will be rendered with darker color
     */
    func initData(percentValue: Double, color: UIColor) {
        self.value = percentValue
        self.color = color
        self.isUserInteractionEnabled = false
        
        renderChart()
    }

    private func renderChart() {
        var dataSet: PieChartDataSet
        
        if value < 100 {
            let entry = PieChartDataEntry(value: value, label: nil)
            let secondEntry = PieChartDataEntry(value: 100 - value, label: nil)
            
            dataSet = PieChartDataSet(entries: [secondEntry, entry], label: nil)
            
            var lighterColor = color
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            if lighterColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
                lighterColor = UIColor(hue: hue, saturation: saturation, brightness: brightness / 0.75, alpha: alpha )
            } else {
                lighterColor = UIColor.darkGray
            }
            
            dataSet.colors = [lighterColor, color]
        } else {
            let diff = value - 100
            let entry = PieChartDataEntry(value: 100 - diff, label: nil)
            let secondEntry = PieChartDataEntry(value: diff, label: nil)
            
            dataSet = PieChartDataSet(entries: [secondEntry, entry], label: nil)
            
            var darkerColor = color
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            if darkerColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
                darkerColor = UIColor(hue: hue, saturation: saturation, brightness: brightness * 0.75, alpha: alpha )
            } else {
                darkerColor = UIColor.darkGray
            }
            
            dataSet.colors = [darkerColor, color]
        }
        
        dataSet.sliceSpace = 0
        
        let data = PieChartData(dataSet: dataSet)
        self.data = data
        
        //All other additions to this function will go here
        self.holeRadiusPercent = 0.6
        self.holeColor = UIColor.clear
        self.transparentCircleRadiusPercent = 0.8
        
        self.legend.form = .none
        self.legend.entries = []
        self.legend.textColor = UIColor.black
        self.legend.drawInside = true
        
        self.data?.setValueTextColor(UIColor.clear)
        
        //This must stay at end of function
        self.notifyDataSetChanged()
    }
}
