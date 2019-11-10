//
//  OverviewTableViewExtension.swift
//  Eatho
//
//  Created by Серафима Зыкова on 22/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import UIKit

class OverviewVC: BaseVC {
    
    private var rationOverview: RationOverview?
    private var chartsData: [NutrientData] = [
        NutrientData(name: "Calories".localized, measure: "\(KCAL)", color: EATHO_MAIN_COLOR),
        NutrientData(name: "Proteins".localized, measure: "\(G)", color: EATHO_PROTEINS),
        NutrientData(name: "Carbs".localized, measure: "\(G)", color: EATHO_CARBS),
        NutrientData(name: "Fats".localized, measure: "\(G)", color: EATHO_FATS)
    ]
    
    var chartsSectionSize: Int {
        get {
            return chartsData.count
        }
    }
    
    var overviewSectionSize: Int {
        get {
            return rationOverview?.data.count ?? 0
        }
    }
    
    let recommendedChartCellHeight: CGFloat = 60
    let recommendedOverviewCellHeight: CGFloat = 38
    
    func setupChartsData(overallNutrition overall: OverallNutrition) {
        
        rationOverview = RationOverview(nutrition: overall)
        
        chartsData[0].value = overall.calories
        chartsData[0].expectedValue = SettingsService.instance.userInfo.nutrition.calories
        chartsData[1].value = overall.proteins
        chartsData[1].expectedValue = SettingsService.instance.userInfo.nutrition.proteins.g
        chartsData[2].value = overall.carbs
        chartsData[2].expectedValue = SettingsService.instance.userInfo.nutrition.carbs.g
        chartsData[3].value = overall.fats
        chartsData[3].expectedValue = SettingsService.instance.userInfo.nutrition.fats.g
    }
    
    func dequeueChartCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cellIdentifier: String) -> ChartCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChartCell {
            let data = chartsData[indexPath.row]
            cell.updateViews(typename: data.name, measure: data.measure, value: data.value, expectedValue: data.expectedValue, color: data.color)
            return cell
        }
        
        return ChartCell()
    }
    
    func dequeueOverviewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cellIdentifier: String) -> UITableViewCell {
        guard let summary = rationOverview?.data else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.textColor = TEXT_COLOR
        cell.detailTextLabel?.textColor = TEXT_COLOR
        
        cell.textLabel?.text = summary[indexPath.row].0
        cell.detailTextLabel?.text = "\(summary[indexPath.row].1.truncated()) \(G)"
        
        if UIScreen.main.bounds.width < SCREEN_WIDTH_LIMIT {
            cell.textLabel?.font = SmallScreenMediumFont
            cell.detailTextLabel?.font = SmallScreenMediumFont
        }
        
        return cell
    }
}

