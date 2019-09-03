//
//  RationNutrientsView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationNutrientsView: UIView {

    @IBOutlet weak var nutrientRelativityView: NutrientsRelativityView!
    
    @IBOutlet weak var collapsedView: UIView!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var collapsedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chartHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalCaloriesLbl: UILabel!
    @IBOutlet weak var expectedCaloriesLbl: UILabel!
    @IBOutlet weak var carbsAmountLbl: UILabel!
    @IBOutlet weak var carbsLbl: UILabel!
    @IBOutlet weak var fatsAmountLbl: UILabel!
    @IBOutlet weak var fatsLbl: UILabel!
    @IBOutlet weak var proteinsAmountLbl: UILabel!
    @IBOutlet weak var proteinsLbl: UILabel!
    @IBOutlet weak var divider: UIView!
    
    @IBOutlet weak var chartView: RationChartView!
    
    @IBOutlet weak var expandImg: UIImageView!
    
    func setupNutrition() {
        let calories = RationService.instance.nutrition.calories
        let carbs = RationService.instance.nutrition.carbs
        let proteins = RationService.instance.nutrition.proteins
        let fats = RationService.instance.nutrition.fats
        
        if (calories != 0) {
            let carbsPercent = (carbs * 4.1 / calories)
            let proteinsPercent = (proteins * 4.1 / calories)
            let fatsPercent = (fats * 9.29 / calories)
            
            nutrientRelativityView.updateView(proteinsPercent: proteinsPercent, carbsPercent: carbsPercent, fatsPercent: fatsPercent)
        } else {
            nutrientRelativityView.updateView(proteinsPercent: 0, carbsPercent: 0, fatsPercent: 0)
        }
        
        totalCaloriesLbl.text = "\(Int(round(calories))) kcal"
        carbsAmountLbl.text = "\(Int(round(carbs))) g"
        proteinsAmountLbl.text = "\(Int(round(proteins))) g"
        fatsAmountLbl.text = "\(Int(round(fats))) g"
        
        chartView.initData(nutrition: RationService.instance.nutrition, userNutrition: SettingsService.instance.userInfo.nutrition)
    }
    
    func setupUserData() {
        if expectedCaloriesLbl != nil {
            expectedCaloriesLbl!.text = "of \(Int(round(SettingsService.instance.userInfo.nutrition.calories))) kcal"
        }
    }
    
    func changeMode(expanded: Bool) {
        UIView.animate(withDuration: 0.3) {
            if expanded {
                self.setupExpandedView()
            } else {
                self.setupCollapsedView()
            }
            
            self.chartView.layoutIfNeeded()
            self.expandedView.layoutIfNeeded()
            self.collapsedView.layoutIfNeeded()
        }
        
    }
    
    func setupCollapsedView() {
        self.expandImg.transform = CGAffineTransform(rotationAngle: 0)
        
        collapsedViewHeight.constant = 52
        chartHeight.constant = 0
        
        totalCaloriesLbl.isHidden = false
        expectedCaloriesLbl.isHidden = false
        carbsAmountLbl.isHidden = false
        carbsLbl.isHidden = false
        fatsAmountLbl.isHidden = false
        fatsLbl.isHidden = false
        proteinsAmountLbl.isHidden = false
        proteinsLbl.isHidden = false
        divider.isHidden = false
        
        chartView.isHidden = true
    }
    
    
    func setupExpandedView() {
        self.expandImg.transform = CGAffineTransform(rotationAngle: .pi)
        
        collapsedViewHeight.constant = 0
        chartHeight.constant = 220
        
        totalCaloriesLbl.isHidden = true
        expectedCaloriesLbl.isHidden = true
        carbsAmountLbl.isHidden = true
        carbsLbl.isHidden = true
        fatsAmountLbl.isHidden = true
        fatsLbl.isHidden = true
        proteinsAmountLbl.isHidden = true
        proteinsLbl.isHidden = true
        divider.isHidden = true
        
        chartView.isHidden = false
    }
}
