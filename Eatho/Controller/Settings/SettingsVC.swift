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
//
//    @IBOutlet weak var genderSwitch: UISegmentedControl!
//    @IBOutlet weak var calculateBtn: EathoButton!
    
    private var settingsList = [ "Nutritional preferences", "Localization preferences", "Shopping list preferences" ]
    private var isConfigureBadgeVisible: Bool {
        get {
            return !AuthService.instance.isLoggedIn || !SettingsService.instance.isConfigured
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(loginHandler), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        
        // data
        if AuthService.instance.isLoggedIn {
            SettingsService.instance.downloadUserData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isConfigureBadgeVisible {
            self.tabBarController?.tabBar.items?[4].badgeValue = "!"
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toAppSettingsSegue"
//        , let index = settingsTableView.indexPathForSelectedRow?.row {
//            switch index {
//            case 0:
//                print("nutrition")
//            case 1:
//                print("localization")
//            case 2:
//                print("shop list")
//            default: ()
//            }
//        }
//    }
    
    // Handlers
    
    @objc func tapHandler() {
        self.view.endEditing(false)
    }
    
    @objc func loginHandler() {
        if !AuthService.instance.isLoggedIn {
            SettingsService.instance.isConfigured = false
        }
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
