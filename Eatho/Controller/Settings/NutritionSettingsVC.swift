//
//  NutritionSettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class NutritionSettingsVC: UIViewController {

    @IBOutlet weak var warningText: UILabel!
    @IBOutlet weak var consultWarningTitle: UILabel!
    @IBOutlet weak var consultWarningText: UILabel!
    @IBOutlet weak var correctWarningTitle: UILabel!
    @IBOutlet weak var correctWarningText: UILabel!
    @IBOutlet weak var correctRationTitle: UILabel!
    @IBOutlet weak var correcRationText: UILabel!
    
    @IBOutlet weak var chartView: UserNutritionChartView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        warningText.text = NUTRITION_WARNING_TEXT
        consultWarningTitle.text = NUTRITION_CONSULT_TITLE
        consultWarningText.text = NUTRITION_CONSULT_TEXT
        correctWarningTitle.text = NUTRITION_CORRECT_TITLE
        correctWarningText.text = NUTRITION_CORRECT_TEXT
        correctRationTitle.text = NUTRITION_NEEDS_TITLE
        correcRationText.text = NUTRITION_NEEDS_TEXT
    
        updateChart()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let autoVC = segue.destination as? AutomaticNutritionCalculationsVC {
            autoVC.delegate = self
        }
        
        if let valuesSetupVC = segue.destination as? NutritionGramsSetupVC {
            valuesSetupVC.delegate = self
        }
    }
    
    func updateChart() {
        chartView.initData(nutrition: SettingsService.instance.userInfo.nutrition)
//        if SettingsService.instance.userInfo.nutrition.isValid {
//            chartView.initData(nutrition: SettingsService.instance.userInfo.nutrition)
//        } else {
//            chartView.isHidden = true
//        }
    }
}

extension NutritionSettingsVC: UserInfoDelegate {
    var userInfo: UserInfo {
        get {
            return SettingsService.instance.userInfo
        }
        
        set {
            SettingsService.instance.userInfo = newValue
            tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.automatic)
            updateChart()
        }
    }

    func userInfoChanged(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
}

extension NutritionSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Macronutrients".localized
        case 1:
            return "Edit".localized
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "basicUserNutrientCell", for: indexPath)
            let userNutrition = SettingsService.instance.userInfo.nutrition
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = CALORIES
                cell.detailTextLabel?.text = "\(userNutrition.calories.truncated()) \(KCAL)"
            case 1:
                cell.textLabel?.text = PROTEINS
                cell.detailTextLabel?.text = "\(truncateDoubleTail(userNutrition.proteins.g)) \(G) / \(truncateDoubleTail(userNutrition.proteins.percent)) %"
            case 2:
                cell.textLabel?.text = CARBS
                cell.detailTextLabel?.text = "\(truncateDoubleTail(userNutrition.carbs.g)) \(G) / \(truncateDoubleTail(userNutrition.carbs.percent)) %"
            case 3:
                cell.textLabel?.text = FATS
                cell.detailTextLabel?.text = "\(truncateDoubleTail(userNutrition.fats.g)) \(G) / \(truncateDoubleTail(userNutrition.fats.percent)) %"
            
            default: ()
            }
            
            cell.textLabel?.textColor = TEXT_COLOR
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.textColor = TEXT_COLOR
            
            return cell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "selectableUserNutrientCell", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Automatic".localized
            case 1:
                cell.textLabel?.text = "Setup values".localized
            default: ()
            }
            
            cell.textLabel?.textColor = EATHO_PURPLE
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .disclosureIndicator
            
            return cell
        default: ()
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toAuthomaticNutritionCalculationsSegue", sender: self)
        case 1:
            performSegue(withIdentifier: "toSetupGramsSegue", sender: self)
        default:
            ()
        }
    }
}
