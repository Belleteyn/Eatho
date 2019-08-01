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
    @IBOutlet weak var activityTxt: UITextField!
    @IBOutlet weak var caloriesShortageTxt: UITextField!
    @IBOutlet weak var calculateBtn: EathoButton!
    
    var activityIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide keyboard 
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.view.addGestureRecognizer(tap)
    }
    
    override func awakeFromNib() {
        // check if settings were configured
        if AuthService.instance.isLoggedIn && SettingsService.instance.isConfigured {
            //todo request settings
        } else {
            self.tabBarController?.tabBar.items?[4].badgeValue = "!"
        }
        
         NotificationCenter.default.addObserver(self, selector: #selector(loginHandler), name: NOTIF_USER_DATA_CHANGED, object: nil)
    }
    
    // Handlers
    
    @objc func tapHandler() {
        self.view.endEditing(false)
    }
    
    @objc func loginHandler() {
        if !AuthService.instance.isLoggedIn {
            SettingsService.instance.isConfigured = false
        }
    }
    
    @objc func pickerViewValueHandler(_ notification: Notification) {
        if let activityLevelIndex = notification.object as? Int {
            print("ACTIVITY CHANGED: \(activityIndex) \(activityLevelIndex)")
            activityIndex = activityLevelIndex
        } else {
            print("fuck it")
        }
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
            activityTxt.isHidden = false
            caloriesShortageTxt.isHidden = false
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
                self.activityTxt.isHidden = true
                self.caloriesShortageTxt.isHidden = true
                self.calculateBtn.isHidden = true
            })
        }
    }

    @IBAction func calculatePressed(_ sender: Any) {
        guard let weightStr = weightTxt.text else { return }
        guard let heightStr = heightTxt.text else { return }
        guard let ageStr = ageTxt.text else { return }
        let shortageStr = caloriesShortageTxt.text ?? "0"

        let weight = Double(weightStr) ?? 0
        let height = Double(heightStr) ?? 0
        let age = Double(ageStr) ?? 0
        let shortage = Double(shortageStr) ?? 0

        var calories = 0.0, p = 0.0, c = 0.0, f = 0.0
        SettingsService.instance.calculateNutrients(weightKg: weight, heightM: height / 100, age: age, gender: genderSwitch.selectedSegmentIndex, activityIndex: activityIndex, shortage: shortage, p: &p, c: &c, f: &f, calories: &calories)

        caloriesTxt.text = "\(round(calories))"
        proteinsMassTxt.text = "\(round(p))"
        proteinsPercentTxt.text = "\(Int(round(p * 4.1 * 100 / calories)))"
        carbsMassTxt.text = "\(round(c))"
        carbsPercentTxt.text = "\(Int(round(c * 4.1 * 100 / calories)))"
        fatsMassTxt.text = "\(round(f))"
        fatsPercentTxt.text = "\(Int(round(f * 9.29 * 100 / calories)))"
    }
    
    @IBAction func activityChange(_ sender: Any) {
        let activityPicker = ActivityPickerVC()
        activityPicker.modalPresentationStyle = .custom
        present(activityPicker, animated: true, completion: nil)
    }
}
