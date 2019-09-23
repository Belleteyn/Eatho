//
//  CreationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 28/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class CreationVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Representation values
    private let nFactsNames = ["Calories", "from fat *", "Proteins", "Carbs", "dietary fiber *", "sugars *", "Fats", "trans *", "saturated *", "monounsaturated *", "polyunsaturated *", "Glycemic index *"]
    private let userDataSectionNames = ["Available *", "Minimal portion *", "Maximal portion *"]
    
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
        subscribeToSettingsError()
        
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
            showInfoAlert(title: "Please enter data", message: "All required fields must be filled")
            return
        }
        
        guard let name = name else { return }
        let type = self.type ?? ""
        
        var available = userDataValues[0] != -1 ? userDataValues[0] : 0
        var min = userDataValues[1] != -1 ? userDataValues[1] : 0
        var max = userDataValues[2] != -1 ? userDataValues[2] : 0
        
        if SettingsService.instance.userInfo.lbsMetrics {
            available = convertMetrics(lbs: available)
            min = convertMetrics(lbs: min)
            max = convertMetrics(lbs: max)
        }
        
        spinner.startAnimating()
        let nutrition = NutritionFacts(calories: nutritionalValues[0], proteins: nutritionalValues[1], carbs: nutritionalValues[3], fats:  nutritionalValues[6], caloriesFromFat:  nutritionalValues[2], fiber:  nutritionalValues[4], sugars: nutritionalValues[5], trans: nutritionalValues[7], saturated: nutritionalValues[8], monounsaturated: nutritionalValues[9], polyunsaturated: nutritionalValues[10], gi: nutritionalValues[11])
        let daily = DailyPortion(min: min, max: max)
        let food = FoodItem(name: name, type: type, availableWeight: available, nutrition: nutrition, dailyPortion: daily)
        
        FoodService.instance.createNewFood(foodItem: food) { (success, error) in
            self.spinner.stopAnimating()
            if success {
                self.navigationController?.popViewController(animated: true)
            } else {
                //todo show error
            }
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
            return "Nutrition facts"
        case 2:
            return "Other parameters"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section != 0 {
            return "* marked optional fields"
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
            cell.setupView(title: nFactsNames[indexPath.row], additionalDesc: "per 100g", placeholder: "0", text: nutritionalValues[indexPath.row] != -1 ?  "\(truncateDoubleTail(nutritionalValues[indexPath.row]))" : nil)
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
                cell.setupView(title: "Name", additionalDesc: "", placeholder: "enter food name", text: name)
                cell.inputFinishedHandle = {
                    (_ val: String) in
                    self.name = val
                }
            } else {
                cell.setupView(title: "Type", additionalDesc: "", placeholder: "choose food type", text: type)
                cell.inputFinishedHandle = {
                    (_ val: String) in
                    self.type = val
                }
            }
            cell.textField.keyboardType = .default
           
        /* nutritional facts section */
        case 1:
            cell.setupView(title: nFactsNames[indexPath.row], additionalDesc: "per 100g", placeholder: "0", text: nutritionalValues[indexPath.row] != -1 ? "\(truncateDoubleTail(nutritionalValues[indexPath.row]))" : nil)
            cell.textField.keyboardType = .decimalPad
            cell.inpuFinishedDecimalHandler = {
                (_ val: Double) in
                self.nutritionalValues[indexPath.row] = val
            }
         
        /* user's data section */
        case 2:
            cell.setupView(title: userDataSectionNames[indexPath.row], additionalDesc: SettingsService.instance.userInfo.lbsMetrics ? "lbs" : "g", placeholder: "0", text: userDataValues[indexPath.row] != -1 ? "\(truncateDoubleTail(userDataValues[indexPath.row]))" : nil)
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
