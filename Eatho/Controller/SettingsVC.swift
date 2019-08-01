//
//  SettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //Outlets
    @IBOutlet weak var kcalTxt: UITextField!
    @IBOutlet weak var carbsTxt: UITextField!
    @IBOutlet weak var proteinsTxt: UITextField!
    @IBOutlet weak var fatsTxt: UITextField!
    
    @IBOutlet weak var autoParamsView: UIStackView!
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var weightTxt: UITextField!
    @IBOutlet weak var heightTxt: UITextField!
    @IBOutlet weak var ageTxt: UITextField!
    @IBOutlet weak var activitySelection: UIPickerView!
    
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

    @IBAction func autoKcalSettingChanged(_ sender: Any) {
        if autoSwitch.isOn {
            genderSwitch.isHidden = false
            weightTxt.isHidden = false
            heightTxt.isHidden = false
            ageTxt.isHidden = false
            activitySelection.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.genderSwitch.isHidden = true
                self.weightTxt.isHidden = true
                self.heightTxt.isHidden = true
                self.ageTxt.isHidden = true
                self.activitySelection.isHidden = true
            })
        }
    }
}
