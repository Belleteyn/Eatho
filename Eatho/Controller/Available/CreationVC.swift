//
//  CreationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 28/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class CreationVC: BaseVC {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Representation values
    private let nFactsNames = [CALORIES, "* \(FROM_FAT)", PROTEINS, CARBS, "* \(FIBER)", "* \(SUGARS)", FATS, "* \(TRANS_FATS)", "* \(SATURATED)", "* \(MONO)", "* \(POLY)", "* \(GI)"]
    private let userDataSectionNames = ["* \(AVAILABLE)", "* \(MIN)", "* \(MAX)"]
    
    private func isEnclosedCell(index: Int) -> Bool {
        return !(index == 0 || index == 2 || index == 3 || index == 6 || index == 11)
    }
    
    private let requiredCellsIndices = [0, 2, 3, 6]
    private func isRequiredFieldsFilled() -> Bool {
        for index in requiredCellsIndices {
            if nutritionalValues[index] == -1 {
                return false
            }
        }
        
        return true
    }
    
    // Input values
    private var name: String?
    private var type: String?
    private var nutritionalValues = Array(repeating: -1.0, count: 12)
    private var userDataValues = Array(repeating: -1.0, count: 3)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.bindHeightToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func highlightRequiredRows() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SingleInputCell {
            cell.highlight()
        }
        
        for index in requiredCellsIndices {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? SingleInputCell {
                cell.highlight()
            }
        }
    }
    
    @objc func tapHandler() {
        self.view.endEditing(false)
    }

    // Actions
    @IBAction func saveClicked(_ sender: Any) {
        for cell in tableView.visibleCells {
            (cell as! SingleInputCell).reset()
        }
        
        if !isRequiredFieldsFilled() || name == nil {
            highlightRequiredRows()
            showInfoAlert(title: ERROR_TITLE_CREATION_DATA_MISSED, message: ERROR_MSG_CREATION_DATA_MISSED)
            return
        }
        
        guard let name = name else { return }
        let type = self.type ?? ""
        
        var available = userDataValues[0] != -1 ? userDataValues[0] : 0
        var min = userDataValues[1] != -1 ? userDataValues[1] : 0
        var max = userDataValues[2] != -1 ? userDataValues[2] : 0
        
        if SettingsService.instance.userInfo.imperialMetrics {
            available = convertMetrics(lbs: available)
            min = convertMetrics(lbs: min)
            max = convertMetrics(lbs: max)
        }
        
        let calories = nutritionalValues[0], p = nutritionalValues[2], c = nutritionalValues[3], f = nutritionalValues[6]
        let cFromFat = nutritionalValues[2] != -1 ? nutritionalValues[2] : nil
        let fiber = nutritionalValues[4] != -1 ? nutritionalValues[4] : nil
        let sugars = nutritionalValues[5] != -1 ? nutritionalValues[5] : nil
        let trans = nutritionalValues[7] != -1 ? nutritionalValues[7] : nil
        let sat = nutritionalValues[8] != -1 ? nutritionalValues[8] : nil
        let mono = nutritionalValues[9] != -1 ? nutritionalValues[9] : nil
        let poly = nutritionalValues[10] != -1 ? nutritionalValues[10] : nil
        let gi = nutritionalValues[11] != -1 ? nutritionalValues[11] : nil
        
        spinner.startAnimating()
        let nutrition = NutritionFacts(calories: calories, proteins: p, carbs: c, fats: f, caloriesFromFat: cFromFat, fiber: fiber, sugars: sugars, trans: trans, saturated: sat, monounsaturated: mono, polyunsaturated: poly, gi: gi)
        let daily = DailyPortion(min: min, max: max)
        let food = FoodItem(name: name, type: type, availableWeight: available, nutrition: nutrition, dailyPortion: daily)
        
        FoodService.instance.createNewFood(foodItem: food) { (_, error) in
            self.spinner.stopAnimating()
            if let error = error {
                self.showErrorAlert(title: ERROR_MSG_FOOD_CREATION_FAILED, message: error.message)
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CreationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return NSLocalizedString("Nutrition facts", comment: "Table headers")
        case 2:
            return NSLocalizedString("Other parameters", comment: "Table headers")
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section != 0 {
            return "* \(NSLocalizedString("marked optional fields", comment: "Table headers"))"
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 12
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* singleInputCellExtra: encosed (gray) cells in Nutrition Facts section */
        if indexPath.section == 1 && isEnclosedCell(index: indexPath.row) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCellExtra", for: indexPath) as? SingleInputCell else { return UITableViewCell() }
            cell.setupView(title: nFactsNames[indexPath.row], additionalDesc: PER100G, placeholder: "0", text: nutritionalValues[indexPath.row] != -1 ?  "\(truncateDoubleTail(nutritionalValues[indexPath.row]))" : nil)
            cell.leftLabel.font = UIFont.systemFont(ofSize: 13)
            cell.inpuFinishedDecimalHandler = {
                (_ val: Double) in
                self.nutritionalValues[indexPath.row] = val
            }
            return cell
        }
        
        /* common cells for all sections */
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell else { return UITableViewCell() }
        
        switch indexPath.section {
            
        /* desc section */
        case 0:
            if indexPath.row == 0 {
                cell.setupView(title: NSLocalizedString("Name", comment: "Food details"), additionalDesc: "", placeholder: NSLocalizedString("enter food name", comment: "Food details"), text: name)
                cell.inputFinishedHandle = {
                    (_ val: String) in
                    self.name = val
                }
            } else {
                cell.setupView(title: NSLocalizedString("Type", comment: "Food details"), additionalDesc: "", placeholder: NSLocalizedString("choose food type", comment: "Food details"), text: type)
                cell.inputFinishedHandle = {
                    (_ val: String) in
                    self.type = val
                }
            }
            cell.textField.keyboardType = .default
           
        /* nutritional facts section */
        case 1:
            cell.setupView(title: nFactsNames[indexPath.row], additionalDesc: PER100G, placeholder: "0", text: nutritionalValues[indexPath.row] != -1 ? "\(truncateDoubleTail(nutritionalValues[indexPath.row]))" : nil)
            cell.textField.keyboardType = .decimalPad
            cell.inpuFinishedDecimalHandler = {
                (_ val: Double) in
                self.nutritionalValues[indexPath.row] = val
            }
         
        /* user's data section */
        case 2:
            cell.setupView(title: userDataSectionNames[indexPath.row], additionalDesc: SettingsService.instance.userInfo.imperialMetrics ? LB : G, placeholder: "0", text: userDataValues[indexPath.row] != -1 ? "\(truncateDoubleTail(userDataValues[indexPath.row]))" : nil)
            cell.textField.keyboardType = .decimalPad
            cell.inpuFinishedDecimalHandler = {
                (_ val: Double) in
                self.userDataValues[indexPath.row] = val
            }
            
        default: ()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && isEnclosedCell(index: indexPath.row) {
            return 37
        }
        return 41
    }
}
