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
    @IBOutlet weak var kcalTxt: UITextField!
    @IBOutlet weak var carbsTxt: UITextField!
    @IBOutlet weak var proteinsTxt: UITextField!
    @IBOutlet weak var fatsTxt: UITextField!
    
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var weightTxt: UITextField!
    @IBOutlet weak var heightTxt: UITextField!
    @IBOutlet weak var ageTxt: UITextField!
    @IBOutlet weak var activitySelection: UIPickerView!
    
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
    
    // Actions
    
    @IBAction func logOutPressed() {
        AuthService.instance.logOut()
        dismiss(animated: true, completion: nil)
    }

}
