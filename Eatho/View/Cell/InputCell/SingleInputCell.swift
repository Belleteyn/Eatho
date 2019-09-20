//
//  SingleInputCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 11/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

typealias StringHandler = ((_: String) -> ())
typealias NumberHandler = ((_: Double) -> ())

class SingleInputCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var inputType: NutritionInputType?
    var userInputType: UserInfoInputType?
    
    var inputChangedHandle: StringHandler?
    var inputFinishedHandle: StringHandler?
    var inputChangedDecimalHandler: NumberHandler?
    var inpuFinishedDecimalHandler: NumberHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    /** also clears all optional values */
    func setupView(title: String, additionalDesc desc: String, placeholder: String, text: String?) {
        self.leftLabel.text = title
        self.rightLabel.text = desc
        self.textField.placeholder = placeholder
        self.textField.text = text
        
        self.inputFinishedHandle = nil
        self.inputChangedHandle = nil
        self.inpuFinishedDecimalHandler = nil
        self.inputChangedDecimalHandler = nil
        self.inputType = nil
        self.userInputType = nil
    }
    
    func setupValues(inputType: NutritionInputType) {
        self.inputType = inputType
        switch inputType {
        case .Calories:
            leftLabel.text = "Calories"
            rightLabel.text = "kcal"
            textField.text = "\(truncateDoubleTail(SettingsService.instance.userInfo.nutrition.calories))"
        default:
            return
        }
    }
    
    func setupValues(inputType: UserInfoInputType) {
        self.userInputType = inputType
        
        switch inputType {
        case .Age:
            textField.text = "\(SettingsService.instance.userInfo.age)"
            leftLabel.text = "Age"
            rightLabel.text = "years"
        case .Height:
            textField.text = "\(SettingsService.instance.userInfo.height)"
            leftLabel.text = "Height"
            rightLabel.text = "cm"
        case .Weight:
            textField.text = "\(SettingsService.instance.userInfo.weight)"
            leftLabel.text = "Weight"
            rightLabel.text = "kg"
        case .CaloriesShortage:
            textField.text = "\(SettingsService.instance.userInfo.caloriesShortage)"
            leftLabel.text = "Calories shortage"
            rightLabel.text = "kcal"
        }
    }
}


extension SingleInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if let inputDoneHandle = inputFinishedHandle {
            inputDoneHandle(text)
            return
        }
        
        guard let val = Double(text) else { return }
        if let inpuFinishedDecimalHandler = inpuFinishedDecimalHandler {
            inpuFinishedDecimalHandler(val)
            return
        }
        
        //TODO: remove !!!
        
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

    
    @objc func textFieldDidChange(_ textField: UITextView) {
        guard let text = textField.text else { return }
        if let inputChangedHandle = inputChangedHandle {
            inputChangedHandle(text)
            return
        }
        
        guard let val = Double(text) else { return }
        if let inputChangedDecimalHandler = inputChangedDecimalHandler {
            inputChangedDecimalHandler(val)
            return
        }

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
