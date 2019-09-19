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
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var typeTxt: UITextField!
    @IBOutlet weak var caloriesTxt: UITextField!
    @IBOutlet weak var carbsTxt: UITextField!
    @IBOutlet weak var proteinsTxt: UITextField!
    @IBOutlet weak var fatsTxt: UITextField!
    @IBOutlet weak var giTxt: UITextField!
    @IBOutlet weak var availableTxt: UITextField!
    @IBOutlet weak var minTxt: UITextField!
    @IBOutlet weak var maxTxt: UITextField!
    @IBOutlet weak var preferredTxt: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let nFactsNames = ["Calories", "from fat", "Proteins", "Carbs", "dietary fiber", "sugars", "Fats", "trans", "saturated", "monounsaturated", "polyunsaturated"]
    private func isEnclosedCell(index: Int) -> Bool {
        return !(index == 0 || index == 2 || index == 3 || index == 6)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.bindHeightToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler() {
        self.view.endEditing(false)
    }

    // Actions
    @IBAction func saveClicked(_ sender: Any) {
        guard let name = nameTxt.text, nameTxt.text != "" else { return }
        guard let calories = caloriesTxt.text, caloriesTxt.text != "" else { return }
        guard let carbs = carbsTxt.text, carbsTxt.text != "" else { return }
        guard let proteins = proteinsTxt.text, proteinsTxt.text != "" else { return }
        guard let fats = fatsTxt.text, fatsTxt.text != "" else { return }
        
        let caloriesVal = Double(calories) ?? 0
        let carbsVal = Double(carbs) ?? 0
        let proteinsVal = Double(proteins) ?? 0
        let fatsVal = Double(fats) ?? 0
        
        let type = typeTxt.text ?? ""
        let gi = Int(giTxt.text!) ?? 0
        let available = Double(availableTxt.text!) ?? 0
        let min = Int(minTxt.text!) ?? 0
        let max = Int(maxTxt.text!) ?? 0
        let preferred = Int(preferredTxt.text!) ?? 0
        
        spinner.startAnimating()
        let nutrition = NutritionFacts(calories: caloriesVal, proteins: proteinsVal, carbs: carbsVal, fats: fatsVal)
        let daily = DailyPortion(min: min, max: max, preferred: preferred)
        let food = FoodItem(name: name, type: type, availableWeight: available, nutrition: nutrition, gi: gi, dailyPortion: daily)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 11
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && isEnclosedCell(index: indexPath.row) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCellExtra", for: indexPath) as? SingleInputCell else { return UITableViewCell() }
            cell.setupView(title: nFactsNames[indexPath.row], additionalDesc: "per 100g", placeholder: "0")
            cell.leftLabel.font = UIFont.systemFont(ofSize: 13)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.setupView(title: "Name", additionalDesc: "", placeholder: "enter food name")
            } else {
                cell.setupView(title: "Type", additionalDesc: "", placeholder: "choose food type")
            }
            cell.textField.keyboardType = .default
        case 1:
            cell.setupView(title: nFactsNames[indexPath.row], additionalDesc: "per 100g", placeholder: "0")
        case 2:
            switch indexPath.row {
            case 0:
                cell.setupView(title: "Available", additionalDesc: SettingsService.instance.userInfo.lbsMetrics ? "lbs" : "g", placeholder: "0")
            case 1:
                cell.setupView(title: "Minimum portion", additionalDesc: SettingsService.instance.userInfo.lbsMetrics ? "lbs" : "g", placeholder: "0")
            case 2:
                cell.setupView(title: "Maximum portion", additionalDesc: SettingsService.instance.userInfo.lbsMetrics ? "lbs" : "g", placeholder: "0")
            default: ()
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
