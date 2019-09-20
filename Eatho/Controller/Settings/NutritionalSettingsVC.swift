//
//  NutritionalSettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

enum NutritionInputType {
    case Calories, Proteins, Carbs, Fats
}

enum UserInfoInputType {
    case Weight, Height, Age, CaloriesShortage
}

class NutritionalSettingsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sectionsCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.bindHeightToKeyboard()
        
        if !SettingsService.instance.userInfo.setupNutrientsFlag {
            sectionsCount = 2
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userNutritionChangedHandler), name: NOTIF_USER_NUTRITION_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pickerValueHandler(_:)), name: NOTIF_USER_ACTIVITY_LEVEL_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NOTIF_USER_DATA_CHANGED, object: nil)
    }

    @objc func tapHandle(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
    
    @objc func reloadData() {
        tableView.reloadData()
    }
    
    @objc func userNutritionChangedHandler(_ notification: Notification) {
        tableView.beginUpdates()
        
        if let info = notification.userInfo, let indices = info["reloadIndices"] as? [Int] {
            var indexArray: [IndexPath] = []
            for index in indices {
                indexArray.append(IndexPath(row: index, section: 0))
            }
            tableView.reloadRows(at: indexArray, with: UITableView.RowAnimation.none)
        }
        
        if let footer = tableView.footerView(forSection: 0) {
            footer.textLabel?.text = SettingsService.instance.userInfo.nutrition.isValid ? "" : "Please set appropriate values"
        }
        
        tableView.endUpdates()
    }
    
    @objc func pickerValueHandler(_ notification: Notification) {
        if let activityLevelIndex = notification.userInfo?["activityIndex"] as? Int {
            var info = SettingsService.instance.userInfo
            info.activityIndex = activityLevelIndex
            SettingsService.instance.userInfo = info
            
            tableView.beginUpdates()
            if let cell = tableView.dequeueReusableCell(withIdentifier: "pickerSelectionCell", for: IndexPath(row: 3, section: 2)) as? PickerSelectionCell {
                cell.setupView(type: SettingsService.instance.activityPickerData[activityLevelIndex][0], description: SettingsService.instance.activityPickerData[activityLevelIndex][1])
            }
            tableView.reloadRows(at: [IndexPath(row: 3, section: 2)], with: UITableView.RowAnimation.automatic)
            tableView.endUpdates()
        }
    }
    
    func autoCalculationSwitchChangedHandle(isOn: Bool) {
        var userInfo = SettingsService.instance.userInfo
        userInfo.setupNutrientsFlag = isOn
        
        tableView.beginUpdates()
        if isOn {
            tableView.insertSections(IndexSet(integer: 2), with: UITableView.RowAnimation.bottom)
            sectionsCount = 3
            
        } else {
            tableView.deleteSections(IndexSet(integer: 2), with: UITableView.RowAnimation.top)
            sectionsCount = 2
            
        }
        tableView.endUpdates()
        
        SettingsService.instance.userInfo = userInfo
    }
}

extension NutritionalSettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 7
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Ration preferences"
        case 1:
            return "Auto calculation"
        case 2:
            return "Parameters for auto calculation"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 && !SettingsService.instance.userInfo.nutrition.isValid {
            tableView.footerView(forSection: section)?.textLabel?.textColor = EATHO_RED
            return "Please set appropriate values"
        }
    
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = EATHO_RED
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 5 {
            return 50
        }
        
        return 46
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // Nutritional values user input
        case 0:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell {
                    cell.setupView(title: "Calories", additionalDesc: "kcal", placeholder: nil, text: "\(truncateDoubleTail(SettingsService.instance.userInfo.nutrition.calories))")
                    cell.inputChangedDecimalHandler = {
                        (_ val: Double) in
                        var info = SettingsService.instance.userInfo
                        info.nutrition.setCalories(kcal: val, updGrams: true)
                        SettingsService.instance.userInfo = info
                        
                        NotificationCenter.default.post(name: NOTIF_USER_NUTRITION_CHANGED, object: nil, userInfo: ["reloadIndices" : [1,2,3]])
                    }
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "doubleInputCell", for: indexPath) as? DoubleInputCell {
                    switch indexPath.row {
                    case 1:
                        cell.setupValues(inputType: .Proteins)
                    case 2:
                        cell.setupValues(inputType: .Carbs)
                    case 3:
                        cell.setupValues(inputType: .Fats)
                    default: ()
                    }
                    return cell
                }
            }
            
        // Enable auto calculation
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as? SwitchCell {
                cell.setupView(defaultSwitchPosition: SettingsService.instance.userInfo.setupNutrientsFlag, handler: autoCalculationSwitchChangedHandle(isOn:))
                return cell
            }
            
        // User data for nutritional calculation
        case 2:
            if indexPath.row == 3 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "pickerSelectionCell", for: indexPath) as? PickerSelectionCell {
                    let index = SettingsService.instance.userInfo.activityIndex
                    cell.setupView(type: SettingsService.instance.activityPickerData[index][0], description: SettingsService.instance.activityPickerData[index][1])
                    return cell
                }
            } else if indexPath.row == 5 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedControlCell", for: indexPath) as? SegmentedControlCell {
                    cell.setupView(title: "Gender", activeSegmentedControlIndex: SettingsService.instance.userInfo.gender) { (selectedIndex) in
                        var info = SettingsService.instance.userInfo
                        info.gender = selectedIndex
                        SettingsService.instance.userInfo = info
                    }
                    return cell
                }
            } else if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = "Calculate nutrition values"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
                cell.textLabel?.textColor = EATHO_PURPLE
                return cell
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell {
                    switch indexPath.row {
                    case 0:
                        cell.setupView(title: "Weight", additionalDesc: SettingsService.instance.userInfo.lbsMetrics ? "lbs" : "kg", placeholder: "0", text: "\(SettingsService.instance.userInfo.weight)")
                        cell.inpuFinishedDecimalHandler = {
                            (_ val: Double) in
                            var info = SettingsService.instance.userInfo
                            info.weight = val
                            SettingsService.instance.userInfo = info
                        }
                    case 1:
                        cell.setupView(title: "Height", additionalDesc: "cm", placeholder: "0", text: "\(SettingsService.instance.userInfo.height)")
                        cell.inpuFinishedDecimalHandler = {
                            (_ val: Double) in
                            var info = SettingsService.instance.userInfo
                            info.height = val
                            SettingsService.instance.userInfo = info
                        }
                    case 2:
                        cell.setupView(title: "Age", additionalDesc: "years", placeholder: "0", text: "\(SettingsService.instance.userInfo.age)")
                        cell.inpuFinishedDecimalHandler = {
                            (_ val: Double) in
                            var info = SettingsService.instance.userInfo
                            info.age = Int(val)
                            SettingsService.instance.userInfo = info
                        }
                    case 4:
                        cell.setupView(title: "Calories shortage", additionalDesc: "kcal", placeholder: "0", text: "\(SettingsService.instance.userInfo.caloriesShortage)")
                        cell.inpuFinishedDecimalHandler = {
                            (_ val: Double) in
                            var info = SettingsService.instance.userInfo
                            info.caloriesShortage = val
                            SettingsService.instance.userInfo = info
                        }
                    default: ()
                    }
                    
                    return cell
                }
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        
        if indexPath.row == 3 {
            performSegue(withIdentifier: "toActivityLevelSegue", sender: self)
        } else if indexPath.row == 6 {
            var info = SettingsService.instance.userInfo
            info.recalculateNutrition()
            SettingsService.instance.userInfo = info
            
            tableView.reloadData()
        }
    }
    
}
