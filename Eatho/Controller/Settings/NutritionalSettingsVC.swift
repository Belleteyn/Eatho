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

class NutritionalSettingsVC: UIViewController {

//    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        scrollView.bindHeightToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userNutritionChangedHandler), name: NOTIF_USER_NUTRITION_CHANGED, object: nil)
    }

    @objc func tapHandle() {
        view.endEditing(false)
    }
    
    @objc func userNutritionChangedHandler() {
        tableView.beginUpdates()
        
        if let footer = tableView.footerView(forSection: 0) {
            footer.textLabel?.text = SettingsService.instance.userInfo.nutrition.isValid ? "" : "Please set appropriate values"
        }
        
        tableView.endUpdates()
    }
}

extension NutritionalSettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
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
        default:
            return ""
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
        switch indexPath.section {
        case 0:
            return 40
        case 1:
            return 360
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell {
                    cell.setupValues(inputType: .Calories)
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "doubleInputCell", for: indexPath) as? DoubleInputCell {
                    cell.setupValues(inputType: .Proteins)
                    return cell
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "doubleInputCell", for: indexPath) as? DoubleInputCell {
                    cell.setupValues(inputType: .Carbs)
                    return cell
                }
            case 3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "doubleInputCell", for: indexPath) as? DoubleInputCell {
                    cell.setupValues(inputType: .Fats)
                    return cell
                }
            default:
                return UITableViewCell()
            }
            
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "autoNutritionPrefsCell", for: indexPath) as? AutoNutritionPrefsCell {
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    
}
