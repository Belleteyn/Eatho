//
//  SingleInputCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 11/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SingleInputCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var placeholder = ""
    var inputType: NutritionInputType?
    var userInputType: UserInfoInputType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
    }
    
    func setupValues(inputType: NutritionInputType) {
        self.inputType = inputType
        switch inputType {
        case .Calories:
            self.placeholder = "\(truncateDoubleTail(SettingsService.instance.userInfo.nutrition.calories))"
            leftLabel.text = "Calories"
            rightLabel.text = "kcal"
            textView.text = placeholder
        default:
            return
        }
    }
    
    func setupValues(inputType: UserInfoInputType) {
        self.userInputType = inputType
        
        switch inputType {
        case .Age:
            self.placeholder = "\(SettingsService.instance.userInfo.age)"
            leftLabel.text = "Age"
            rightLabel.text = "years"
        case .Height:
            self.placeholder = "\(SettingsService.instance.userInfo.height)"
            leftLabel.text = "Height"
            rightLabel.text = "cm"
        case .Weight:
            self.placeholder = "\(SettingsService.instance.userInfo.weight)"
            leftLabel.text = "Weight"
            rightLabel.text = "kg"
        case .CaloriesShortage:
            self.placeholder = "\(SettingsService.instance.userInfo.caloriesShortage)"
            leftLabel.text = "Calories shortage"
            rightLabel.text = "kcal"
        }
        
        textView.text = placeholder
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
        }
        
        guard let text = textView.text, let val = Double(text) else { return }
        guard let type = userInputType else { return }
        var info = SettingsService.instance.userInfo
        
        switch type {
        case .Age:
            info.age = Int(val)
        case .Height:
            info.height = val
        case .Weight:
            info.weight = val
        case .CaloriesShortage:
            info.caloriesShortage = val
        }
        
        SettingsService.instance.userInfo = info
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, let val = Double(text) else { return }
        guard let type = inputType else { return }
        
        var info = SettingsService.instance.userInfo
        if type == .Calories {
            info.nutrition.setCalories(kcal: val, updGrams: true)
        }

        // update in storage and on server
        SettingsService.instance.userInfo = info
        if type == .Calories {
            NotificationCenter.default.post(name: NOTIF_USER_NUTRITION_CHANGED, object: nil, userInfo: ["reloadIndices" : [1,2,3]])
        }
    }
}
