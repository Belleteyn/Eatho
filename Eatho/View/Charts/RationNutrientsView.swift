//
//  RationNutrientsView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationNutrientsView: UIView {

    @IBOutlet weak var totalCaloriesLbl: UILabel!
    @IBOutlet weak var expectedCaloriesLbl: UILabel!
    
    @IBOutlet weak var carbsAmountLbl: UILabel!
    @IBOutlet weak var fatsAmountLbl: UILabel!
    @IBOutlet weak var proteinsAmountLbl: UILabel!
    
    @IBOutlet weak var carbsLbl: UILabel!
    @IBOutlet weak var fatsLbl: UILabel!
    @IBOutlet weak var proteinsLbl: UILabel!
    
    private var overview: RationOverview?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        carbsLbl.text = CARBS
        carbsLbl.textColor = EATHO_CARBS
        
        fatsLbl.text = FATS
        fatsLbl.textColor = EATHO_FATS
        
        proteinsLbl.text = PROTEINS
        proteinsLbl.textColor = EATHO_PROTEINS
        
        //change font size for small screens
        if UIScreen.main.bounds.width < SCREEN_WIDTH_LIMIT {
            totalCaloriesLbl.font = SmallScreenMediumFont
            carbsAmountLbl.font = SmallScreenMediumFont
            fatsAmountLbl.font = SmallScreenMediumFont
            proteinsAmountLbl.font = SmallScreenMediumFont
            
            expectedCaloriesLbl.font = SmallScreenSmallFont
            carbsLbl.font = SmallScreenSmallFont
            fatsLbl.font = SmallScreenSmallFont
            proteinsLbl.font = SmallScreenSmallFont
        }
    }
    
    func setupNutrition(overallNureirion nutrition: OverallNutrition?) {
        guard let nutrition = nutrition else { return }
        self.overview = RationOverview(nutrition: nutrition)
        
        let calories = nutrition.calories
        let carbs = nutrition.carbs
        let proteins = nutrition.proteins
        let fats = nutrition.fats
        
        totalCaloriesLbl.text = "\(Int(round(calories))) \(KCAL)"
        carbsAmountLbl.text = "\(Int(round(carbs))) \(G)"
        proteinsAmountLbl.text = "\(Int(round(proteins))) \(G)"
        fatsAmountLbl.text = "\(Int(round(fats))) \(G)"
    }
    
    func setupUserData() {
        if expectedCaloriesLbl != nil {
            expectedCaloriesLbl!.text = "\(OF) \(Int(round(SettingsService.instance.userInfo.nutrition.calories))) \(KCAL)"
        }
    }
    
    func hide() {
        totalCaloriesLbl.isHidden = true
        expectedCaloriesLbl.isHidden = true
        
        carbsLbl.isHidden = true
        carbsAmountLbl.isHidden = true
        
        proteinsLbl.isHidden = true
        proteinsAmountLbl.isHidden = true
        
        fatsLbl.isHidden = true
        fatsAmountLbl.isHidden = true
    }
    
    func reveal() {
        totalCaloriesLbl.isHidden = false
        expectedCaloriesLbl.isHidden = false
        
        carbsLbl.isHidden = false
        carbsAmountLbl.isHidden = false
        
        proteinsLbl.isHidden = false
        proteinsAmountLbl.isHidden = false
        
        fatsLbl.isHidden = false
        fatsAmountLbl.isHidden = false
    }
}
