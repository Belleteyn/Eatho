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
    
    var delegate: UserInfoDelegate?
    private enum UserParams {
        case Weight, Height, Age, Gender, Activity, CalShortage, Btn
        static let types: [UserParams] = [.Weight, .Height, .Age, .Gender, .Activity, .CalShortage, .Btn]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
        guard var delegate = delegate else { return }

        delegate.userInfo.activityIndex = index
        delegate.userInfoChanged(userInfo: delegate.userInfo)
        
        tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
    }
    
    
}

extension AutomaticNutritionCalculationsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < UserParams.types.count else {
            return UITableViewCell()
        }
        
        let type = UserParams.types[indexPath.row]
        switch type {
        case .Activity:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "pickerSelectionCell", for: indexPath) as? PickerSelectionCell {
                
                guard let index = delegate?.userInfo.activityIndex else { return cell }
                cell.setupView(type: SettingsService.instance.activityPickerData[index][0], description: SettingsService.instance.activityPickerData[index][1])
                
                return cell
            }
        case .Gender:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedControlCell", for: indexPath) as? SegmentedControlCell {
                
                guard let gender = delegate?.userInfo.gender else { return cell }
                cell.setupView(title: NSLocalizedString("Gender", comment: "Settings"), activeSegmentedControlIndex: gender) { (selectedIndex) in
                    
                    guard var delegate = self.delegate else { return }
                    delegate.userInfo.gender = selectedIndex
                    delegate.userInfoChanged(userInfo: delegate.userInfo)
                }
                return cell
            }
        case .Btn:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = NSLocalizedString("Calculate nutrition values", comment: "Settings")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
            cell.textLabel?.textColor = EATHO_PURPLE
            return cell
        default:
            return configureSungleViewCell(type: type, indexPath: indexPath)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            guard var delegate = self.delegate else { return }
            delegate.userInfo.recalculateNutrition()
            delegate.userInfoChanged(userInfo: delegate.userInfo)
            
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func configureSungleViewCell(type: UserParams, indexPath: IndexPath) -> SingleInputCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell {
            
            switch type {
            case .Weight:
                guard let lbsMetrics = delegate?.userInfo.lbsMetrics else { return cell }
                guard let weight = delegate?.userInfo.weight else { return cell }
                
                cell.setupView(title: NSLocalizedString("Weight", comment: "Settings"), additionalDesc: lbsMetrics ? LB : NSLocalizedString("kg", comment: "Settings"), placeholder: "0", text: "\(weight)")
                cell.inpuFinishedDecimalHandler = {
                    (_ val: Double) in
                    
                    guard var delegate = self.delegate else { return }
                    delegate.userInfo.weight = val
                    delegate.userInfoChanged(userInfo: delegate.userInfo)
                }
                
            case .Height:
                guard let height = delegate?.userInfo.height else { return cell }
                
                cell.setupView(title: NSLocalizedString("Height", comment: "Settings"), additionalDesc: NSLocalizedString("cm", comment: "Settings"), placeholder: "0", text: "\(height)")
                cell.inpuFinishedDecimalHandler = {
                    (_ val: Double) in
                    
                    guard var delegate = self.delegate else { return }
                    delegate.userInfo.height = val
                    delegate.userInfoChanged(userInfo: delegate.userInfo)
                }
                
            case .Age:
                guard let age = delegate?.userInfo.age else { return cell }
                
                cell.setupView(title: NSLocalizedString("Age", comment: "Settings"), additionalDesc: NSLocalizedString("years", comment: "Settings"), placeholder: "0", text: "\(age)")
                cell.inpuFinishedDecimalHandler = {
                    (_ val: Double) in
                    
                    guard var delegate = self.delegate else { return }
                    delegate.userInfo.age = Int(val)
                    delegate.userInfoChanged(userInfo: delegate.userInfo)
                }
                
            case .CalShortage:
                guard let caloriesShortage = delegate?.userInfo.caloriesShortage else { return cell }
                
                cell.setupView(title: NSLocalizedString("Calories shortage", comment: "Settings"), additionalDesc: KCAL, placeholder: "0", text: "\(caloriesShortage)")
                cell.inpuFinishedDecimalHandler = {
                    (_ val: Double) in
                    
                    guard var delegate = self.delegate else { return }
                    delegate.userInfo.caloriesShortage = val
                    delegate.userInfoChanged(userInfo: delegate.userInfo)
                }
                
            default: ()
            }
            return cell
        }
        
        return SingleInputCell()
    }
}
