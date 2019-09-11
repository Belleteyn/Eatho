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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let inputType = inputType, let text = textView.text, let val = Double(text) else { return }
        var info = SettingsService.instance.userInfo
        
        switch inputType {
        case .Calories:
            info.nutrition.setCalories(kcal: val, updGrams: true)
        default: ()
        }
        
        // update in storage and on server
        SettingsService.instance.userInfo = info
    }
}
