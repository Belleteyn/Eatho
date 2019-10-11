//
//  AutomaticNutritionCalculationsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 11/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AutomaticNutritionCalculationsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var info = SettingsService.instance.userInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        info = SettingsService.instance.userInfo
    }
    
    @objc func tapHandle(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pickerVC = segue.destination as? ActivityPickerVC {
            pickerVC.delegate = self
        }
    }
}

extension AutomaticNutritionCalculationsVC: PickerViewIndexDelegate {
    func indexChanged(index: Int) {
        info.activityIndex = index
        SettingsService.instance.userInfo = info
        
        tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
    }
    
    
}

extension AutomaticNutritionCalculationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "pickerSelectionCell", for: indexPath) as? PickerSelectionCell {
                let index = info.activityIndex
                
                cell.setupView(type: SettingsService.instance.activityPickerData[index][0], description: SettingsService.instance.activityPickerData[index][1])
                return cell
            }
        } else if indexPath.row == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedControlCell", for: indexPath) as? SegmentedControlCell {
                cell.setupView(title: NSLocalizedString("Gender", comment: "Settings"), activeSegmentedControlIndex: info.gender) { (selectedIndex) in
                    self.info.gender = selectedIndex
                    SettingsService.instance.userInfo = self.info
                }
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell {
                switch indexPath.row {
                case 0:
                    cell.setupView(title: NSLocalizedString("Weight", comment: "Settings"), additionalDesc: info.lbsMetrics ? LB : NSLocalizedString("kg", comment: "Settings"), placeholder: "0", text: "\(info.weight)")
                    cell.inpuFinishedDecimalHandler = {
                        (_ val: Double) in
                        print("!!!")
                        self.info.weight = val
                        SettingsService.instance.userInfo = self.info
                    }
                case 1:
                    cell.setupView(title: NSLocalizedString("Height", comment: "Settings"), additionalDesc: NSLocalizedString("cm", comment: "Settings"), placeholder: "0", text: "\(info.height)")
                    cell.inpuFinishedDecimalHandler = {
                        (_ val: Double) in
                        self.info.height = val
                        SettingsService.instance.userInfo = self.info
                    }
                case 2:
                    cell.setupView(title: NSLocalizedString("Age", comment: "Settings"), additionalDesc: NSLocalizedString("years", comment: "Settings"), placeholder: "0", text: "\(info.age)")
                    cell.inpuFinishedDecimalHandler = {
                        (_ val: Double) in
                        self.info.age = Int(val)
                        SettingsService.instance.userInfo = self.info
                    }
                case 5:
                    cell.setupView(title: NSLocalizedString("Calories shortage", comment: "Settings"), additionalDesc: KCAL, placeholder: "0", text: "\(info.caloriesShortage)")
                    cell.inpuFinishedDecimalHandler = {
                        (_ val: Double) in
                        self.info.caloriesShortage = val
                        SettingsService.instance.userInfo = self.info
                    }
                default: ()
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
