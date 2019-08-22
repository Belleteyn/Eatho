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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var caloriesTxt: UITextField!
    @IBOutlet weak var proteinsMassTxt: UITextField!
    @IBOutlet weak var proteinsPercentTxt: UITextField!
    @IBOutlet weak var fatsMassTxt: UITextField!
    @IBOutlet weak var fatsPercentTxt: UITextField!
    @IBOutlet weak var carbsMassTxt: UITextField!
    @IBOutlet weak var carbsPercentTxt: UITextField!
    
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var weightTxt: UITextField!
    @IBOutlet weak var heightTxt: UITextField!
    @IBOutlet weak var ageTxt: UITextField!
    @IBOutlet weak var caloriesShortageTxt: UITextField!
    @IBOutlet weak var dailyActivityBtn: UIButton!
    @IBOutlet weak var calculateBtn: EathoButton!
    
    var activityIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        
        // keyboard
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.view.addGestureRecognizer(tap)
        
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
        if !AuthService.instance.isLoggedIn || !SettingsService.instance.isConfigured {
            self.tabBarController?.tabBar.items?[4].badgeValue = "!"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //todo: save settings, upload to server
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
        if let activityLevelIndex = notification.userInfo?["activityIndex"] as? Int {
            activityIndex = activityLevelIndex
            dailyActivityBtn.setTitle("\(SettingsService.instance.activityPickerData[activityIndex])", for: .normal)
            dailyActivityBtn.setTitleColor(TEXT_COLOR, for: .normal)
        }
    }
    
    @objc func setupData() {
        let info = SettingsService.instance.userInfo
        
        caloriesTxt.text = "\(info.nutrition.calories)"
        proteinsMassTxt.text = "\(info.nutrition.proteins["g"]!)"
        proteinsPercentTxt.text = "\(info.nutrition.proteins["percent"]!)"
        carbsMassTxt.text = "\(info.nutrition.carbs["g"]!)"
        carbsPercentTxt.text = "\(info.nutrition.carbs["percent"]!)"
        fatsMassTxt.text = "\(info.nutrition.fats["g"]!)"
        fatsPercentTxt.text = "\(info.nutrition.fats["percent"]!)"
        
        autoSwitch.isOn = info.setupNutrientsFlag
        genderSwitch.selectedSegmentIndex = info.gender
        weightTxt.text = "\(info.weight)"
        heightTxt.text = "\(info.height)"
        ageTxt.text = "\(info.age)"
        caloriesShortageTxt.text = "\(info.caloriesShortage)"
        dailyActivityBtn.setTitle("\(SettingsService.instance.activityPickerData[info.activityIndex])", for: .normal)
        dailyActivityBtn.setTitleColor(TEXT_COLOR, for: .normal)
        
        activityIndex = info.activityIndex
    }
    
    // Actions
    
    @IBAction func logOutPressed() {
        AuthService.instance.logOut()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func autoSwitchChanged(_ sender: Any) {
        if autoSwitch.isOn {
            genderSwitch.isHidden = false
            weightTxt.isHidden = false
            heightTxt.isHidden = false
            ageTxt.isHidden = false
            caloriesShortageTxt.isHidden = false
            dailyActivityBtn.isHidden = false
            calculateBtn.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.genderSwitch.isHidden = true
                self.weightTxt.isHidden = true
                self.heightTxt.isHidden = true
                self.ageTxt.isHidden = true
                self.caloriesShortageTxt.isHidden = true
                self.dailyActivityBtn.isHidden = true
                self.calculateBtn.isHidden = true
            })
        }
    }

    @IBAction func calculatePressed(_ sender: Any) {
        guard let weightStr = weightTxt.text else { return }
        guard let heightStr = heightTxt.text else { return }
        guard let ageStr = ageTxt.text else { return }
        let shortageStr = caloriesShortageTxt.text ?? "0"
        let gender = genderSwitch.selectedSegmentIndex

        let weight = Double(weightStr) ?? 0
        let height = Double(heightStr) ?? 0
        let age = Int(ageStr) ?? 0
        let shortage = Double(shortageStr) ?? 0

        var info = SettingsService.instance.userInfo
        info.gender = gender
        info.weight = weight
        info.height = height
        info.age = age
        info.caloriesShortage = shortage
        info.activityIndex = self.activityIndex
        info.recalculateNutrition()
        
        SettingsService.instance.userInfo = info
        setupData()
    }
    
    @IBAction func dailyActivityBtnPressed(_ sender: Any) {
        let activityPicker = ActivityPickerVC()
        activityPicker.modalPresentationStyle = .custom
        present(activityPicker, animated: true, completion: nil)
    }
}
