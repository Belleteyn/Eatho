//
//  DoubleInputCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 11/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class DoubleInputCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var weightTextView: UITextView!
    @IBOutlet weak var percentTextView: UITextView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    var weightPlaceholder = ""
    var percentPlaceholder = ""
    
    var inputType: NutritionInputType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weightTextView.delegate = self
        percentTextView.delegate = self
        
        weightLabel.text = "g"
        percentLabel.text = "%"
    }

    func setupValues(inputType: NutritionInputType) {
        self.inputType = inputType
        
        let info = SettingsService.instance.userInfo
        
        switch inputType {
        case .Proteins:
            percentPlaceholder = "\(truncateDoubleTail(info.nutrition.proteins["percent"]!))"
            weightPlaceholder = "\(truncateDoubleTail(info.nutrition.proteins["g"]!))"
            mainLabel.text = "Proteins"
        case .Carbs:
            percentPlaceholder = "\(truncateDoubleTail(info.nutrition.carbs["percent"]!))"
            weightPlaceholder = "\(truncateDoubleTail(info.nutrition.carbs["g"]!))"
            mainLabel.text = "Carbs"
        case .Fats:
            percentPlaceholder = "\(truncateDoubleTail(info.nutrition.fats["percent"]!))"
            weightPlaceholder = "\(truncateDoubleTail(info.nutrition.fats["g"]!))"
            mainLabel.text = "Fats"
        default:
            return
        }
        
        weightTextView.text = weightPlaceholder
        percentTextView.text = percentPlaceholder
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == weightTextView && textView.text == weightPlaceholder {
            textView.text = ""
        } else if textView == percentTextView && textView.text == percentPlaceholder {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == weightTextView && textView.text == "" {
            textView.text = weightPlaceholder
        } else if textView == percentTextView && textView.text == "" {
            textView.text = percentPlaceholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let inputType = inputType, let text = textView.text, let val = Double(text) else { return }
        
        var info = SettingsService.instance.userInfo
        
        switch inputType {
        case .Proteins:
            if textView == percentTextView {
                info.nutrition.setProteins(grams: nil, percent: val, updCalories: true)
                weightTextView.text = "\(truncateDoubleTail(info.nutrition.proteins["g"]!))"
            } else {
                info.nutrition.setProteins(grams: val, percent: nil, updCalories: true)
                percentTextView.text = "\(truncateDoubleTail(info.nutrition.proteins["percent"]!))"
            }
            NotificationCenter.default.post(name: NOTIF_USER_NUTRITION_CHANGED, object: nil, userInfo: ["reloadIndices" : [0,2,3]])
        case .Carbs:
            if textView == percentTextView {
                info.nutrition.setCarbs(grams: nil, percent: val, updCalories: true)
                weightTextView.text = "\(truncateDoubleTail(info.nutrition.carbs["g"]!))"
            } else {
                info.nutrition.setCarbs(grams: val, percent: nil, updCalories: true)
                percentTextView.text = "\(truncateDoubleTail(info.nutrition.carbs["percent"]!))"
            }
            NotificationCenter.default.post(name: NOTIF_USER_NUTRITION_CHANGED, object: nil, userInfo: ["reloadIndices" : [0,1,3]])
        case .Fats:
            if textView == percentTextView {
                info.nutrition.setFats(grams: nil, percent: val, updCalories: true)
                weightTextView.text = "\(truncateDoubleTail(info.nutrition.fats["g"]!))"
            } else {
                info.nutrition.setFats(grams: val, percent: nil, updCalories: true)
                percentTextView.text = "\(truncateDoubleTail(info.nutrition.fats["percent"]!))"
            }
            NotificationCenter.default.post(name: NOTIF_USER_NUTRITION_CHANGED, object: nil, userInfo: ["reloadIndices" : [0,1,2]])
        default: ()
        }
        
        SettingsService.instance.userInfo = info
    }


}
