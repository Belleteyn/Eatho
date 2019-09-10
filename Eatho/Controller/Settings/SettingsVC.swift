//
//  SettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    //Outlets
    @IBOutlet weak var settingsTableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
//    @IBOutlet weak var caloriesTxt: UITextField!
//    @IBOutlet weak var proteinsMassTxt: UITextField!
//    @IBOutlet weak var proteinsPercentTxt: UITextField!
//    @IBOutlet weak var fatsMassTxt: UITextField!
//    @IBOutlet weak var fatsPercentTxt: UITextField!
//    @IBOutlet weak var carbsMassTxt: UITextField!
//    @IBOutlet weak var carbsPercentTxt: UITextField!
//
//    @IBOutlet weak var autoSwitch: UISwitch!
//    @IBOutlet weak var genderSwitch: UISegmentedControl!
//    @IBOutlet weak var weightTxt: UITextField!
//    @IBOutlet weak var heightTxt: UITextField!
//    @IBOutlet weak var ageTxt: UITextField!
//    @IBOutlet weak var caloriesShortageTxt: UITextField!
//    @IBOutlet weak var dailyActivityBtn: UIButton!
//    @IBOutlet weak var calculateBtn: EathoButton!
//
//    @IBOutlet weak var warningLbl: UILabel!
    
//    var activityIndex: Int = 0
    private var settingsList = [ "Nutritional preferences", "Localization preferences", "Shopping list preferences" ]
    private var isConfigureBadgeVisible: Bool {
        get {
            return !AuthService.instance.isLoggedIn || !SettingsService.instance.isConfigured
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        // text field delegates
//        caloriesTxt.delegate = self
//        proteinsMassTxt.delegate = self
//        proteinsPercentTxt.delegate = self
//        fatsMassTxt.delegate = self
//        fatsPercentTxt.delegate = self
//        carbsMassTxt.delegate = self
//        carbsPercentTxt.delegate = self
        
        // keyboard
        view.bindToKeyboard()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
//        self.view.addGestureRecognizer(tap)
        
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(loginHandler), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupData), name: NOTIF_USER_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pickerValueHandler(_:)), name: NOTIF_USER_ACTIVITY_LEVEL_CHANGED, object: nil)
        
        // data
        if AuthService.instance.isLoggedIn {
            SettingsService.instance.downloadUserData()
            
            if SettingsService.instance.isConfigured {
                setupData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isConfigureBadgeVisible {
            self.tabBarController?.tabBar.items?[4].badgeValue = "!"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        if segue.identifier == "toAppSettingsSegue"
        , let index = settingsTableView.indexPathForSelectedRow?.row {
            switch index {
            case 0:
                print("nutrition")
            case 1:
                print("localization")
            case 2:
                print("shop list")
            default: ()
            }
        }
    }
    
    // Handlers
    
    @objc func tapHandler() {
        self.view.endEditing(false)
        setupData()
    }
    
    @objc func loginHandler() {
        if !AuthService.instance.isLoggedIn {
            SettingsService.instance.isConfigured = false
        }
    }
    
    @objc func pickerValueHandler(_ notification: Notification) {
//        if let activityLevelIndex = notification.userInfo?["activityIndex"] as? Int {
//            activityIndex = activityLevelIndex
//            dailyActivityBtn.setTitle("\(SettingsService.instance.activityPickerData[activityIndex])", for: .normal)
//            dailyActivityBtn.setTitleColor(TEXT_COLOR, for: .normal)
//        }
    }
    
    @objc func setupData() {
//        let info = SettingsService.instance.userInfo
//
//        caloriesTxt.text = "\(info.nutrition.calories)"
//        proteinsMassTxt.text = "\(round(info.nutrition.proteins["g"]! * 10) / 10)"
//        proteinsPercentTxt.text = "\(round(info.nutrition.proteins["percent"]! * 10) / 10)"
//        carbsMassTxt.text = "\(round(info.nutrition.carbs["g"]! * 10) / 10)"
//        carbsPercentTxt.text = "\(round(info.nutrition.carbs["percent"]! * 10) / 10)"
//        fatsMassTxt.text = "\(round(info.nutrition.fats["g"]! * 10) / 10)"
//        fatsPercentTxt.text = "\(round(info.nutrition.fats["percent"]! * 10) / 10)"
//
//        autoSwitch.isOn = info.setupNutrientsFlag
//        genderSwitch.selectedSegmentIndex = info.gender
//        weightTxt.text = "\(info.weight)"
//        heightTxt.text = "\(info.height)"
//        ageTxt.text = "\(info.age)"
//        caloriesShortageTxt.text = "\(info.caloriesShortage)"
//        dailyActivityBtn.setTitle("\(SettingsService.instance.activityPickerData[info.activityIndex])", for: .normal)
//        dailyActivityBtn.setTitleColor(TEXT_COLOR, for: .normal)
//
//        activityIndex = info.activityIndex
//        warningLbl.isHidden = info.nutrition.isValid
    }
    
    // Actions
    @IBAction func autoSwitchChanged(_ sender: Any) {
//        if autoSwitch.isOn {
//            genderSwitch.isHidden = false
//            weightTxt.isHidden = false
//            heightTxt.isHidden = false
//            ageTxt.isHidden = false
//            caloriesShortageTxt.isHidden = false
//            dailyActivityBtn.isHidden = false
//            calculateBtn.isHidden = false
//
//            UIView.animate(withDuration: 0.3, animations: {
//                self.view.layoutIfNeeded()
//            })
//        } else {
//            UIView.animate(withDuration: 0.25, animations: {
//                self.genderSwitch.isHidden = true
//                self.weightTxt.isHidden = true
//                self.heightTxt.isHidden = true
//                self.ageTxt.isHidden = true
//                self.caloriesShortageTxt.isHidden = true
//                self.dailyActivityBtn.isHidden = true
//                self.calculateBtn.isHidden = true
//            })
//        }
    }

    @IBAction func calculatePressed(_ sender: Any) {
//        guard let weightStr = weightTxt.text else { return }
//        guard let heightStr = heightTxt.text else { return }
//        guard let ageStr = ageTxt.text else { return }
//        let shortageStr = caloriesShortageTxt.text ?? "0"
//        let gender = genderSwitch.selectedSegmentIndex
//
//        let weight = Double(weightStr) ?? 0
//        let height = Double(heightStr) ?? 0
//        let age = Int(ageStr) ?? 0
//        let shortage = Double(shortageStr) ?? 0
//
//        var info = SettingsService.instance.userInfo
//        info.gender = gender
//        info.weight = weight
//        info.height = height
//        info.age = age
//        info.caloriesShortage = shortage
//        info.activityIndex = self.activityIndex
//        info.recalculateNutrition()
//
//        SettingsService.instance.userInfo = info
//        setupData()
    }
    
    @IBAction func dailyActivityBtnPressed(_ sender: Any) {
//        let activityPicker = ActivityPickerVC()
//        activityPicker.modalPresentationStyle = .custom
//        present(activityPicker, animated: true, completion: nil)
    }
}

extension SettingsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text = textField.text, let val = Double(text) {
//            var info = SettingsService.instance.userInfo
//            
//            switch textField {
//            case caloriesTxt:
//                info.nutrition.setCalories(kcal: val, updGrams: true)
//            case proteinsPercentTxt:
//                info.nutrition.setProteins(grams: nil, percent: val, updCalories: true)
//            case proteinsMassTxt:
//                info.nutrition.setProteins(grams: val, percent: nil, updCalories: true)
//            case carbsPercentTxt:
//                info.nutrition.setCarbs(grams: nil, percent: val, updCalories: true)
//            case carbsMassTxt:
//                info.nutrition.setCarbs(grams: val, percent: nil, updCalories: true)
//            case fatsPercentTxt:
//                info.nutrition.setFats(grams: nil, percent: val, updCalories: true)
//            case fatsMassTxt:
//                info.nutrition.setFats(grams: val, percent: nil, updCalories: true)
//            default:
//                print(textField)
//            }
//            
//            // update in storage and on server
//            SettingsService.instance.userInfo = info
//            warningLbl.isHidden = info.nutrition.isValid
//        }
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func addBadgeToCell(cell: UITableViewCell) {
        if isConfigureBadgeVisible {
            let size: CGFloat = cell.frame.height / 2
            let badge = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
            badge.text = "!"
            badge.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.black)
            badge.layer.cornerRadius = size / 2
            badge.layer.masksToBounds = true
            badge.textColor = UIColor.white
            badge.textAlignment = .center
            badge.backgroundColor = EATHO_RED
            cell.accessoryView = badge
        } else {
            cell.accessoryView = cell.editingAccessoryView
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return settingsList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
            return 46
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
            cell.textLabel?.text = AuthService.instance.userEmail
            cell.textLabel?.textColor = TEXT_COLOR
            cell.detailTextLabel?.text = "account settings"
            cell.detailTextLabel?.textColor = TEXT_COLOR
            cell.imageView?.image = UIImage(named: "logo.png")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            cell.textLabel?.textColor = TEXT_COLOR
            cell.textLabel?.text = settingsList[indexPath.row]
            if indexPath.row == 0 { //Nutritional preferences
                addBadgeToCell(cell: cell)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0: //nutrition
                performSegue(withIdentifier: "toNutritionSettingsSegue", sender: self)
            case 1: //localization
                performSegue(withIdentifier: "toLocalizationSettingsSegue", sender: self)
            case 2: //shopping list
                performSegue(withIdentifier: "toShoppingListSettingsSegue", sender: self)
            default:
                print("unknown settings segue called")
            }
        default: ()
        }
    }
    
}
