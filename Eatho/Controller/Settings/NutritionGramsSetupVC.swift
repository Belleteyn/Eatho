//
//  NutritionGramsSetupVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 11/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class NutritionGramsSetupVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: UserInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler() {
        view.endEditing(false)
    }
}


extension NutritionGramsSetupVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userInfo = self.delegate?.userInfo else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetailNutritionCell", for: indexPath)
            cell.textLabel?.text = CALORIES
            cell.textLabel?.textColor = TEXT_COLOR
            
            cell.detailTextLabel?.text = "\(truncateDoubleTail(userInfo.nutrition.calories)) \(KCAL)"
            cell.detailTextLabel?.textColor = TEXT_COLOR
            
            cell.backgroundColor = EATHO_LIGHT_PURPLE_OPACITY30
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell {
            switch indexPath.row {
            case 1:
                cell.setupView(title: PROTEINS, additionalDesc: "\(G), \(truncateDoubleTail(userInfo.nutrition.proteins["percent"] ?? 0)) %", placeholder: "0", text: "\(userInfo.nutrition.proteins["g"] ?? 0)")
                
                cell.inpuFinishedDecimalHandler = {(val: Double) in
                    guard var delegate = self.delegate else { return }
                    delegate.userInfo.nutrition.setProteins(grams: val)
                    delegate.userInfoChanged(userInfo: delegate.userInfo)
                    tableView.reloadData()
                }
            case 2:
                cell.setupView(title: CARBS, additionalDesc: "\(G), \(truncateDoubleTail(userInfo.nutrition.carbs["percent"] ?? 0)) %", placeholder: "0", text: "\(userInfo.nutrition.carbs["g"] ?? 0)")
                
                cell.inpuFinishedDecimalHandler = {(val: Double) in
                    guard var delegate = self.delegate else { return }
                    delegate.userInfo.nutrition.setCarbs(grams: val)
                    delegate.userInfoChanged(userInfo: delegate.userInfo)
                    tableView.reloadData()
                }
            case 3:
                cell.setupView(title: FATS, additionalDesc: "\(G), \(truncateDoubleTail(userInfo.nutrition.fats["percent"] ?? 0)) %", placeholder: "0", text: "\(userInfo.nutrition.fats["g"] ?? 0)")
                

            default: ()
            }
            
            cell.inpuFinishedDecimalHandler = {(val: Double) in
                guard var delegate = self.delegate else { return }
                delegate.userInfo.nutrition.setVal(index: indexPath.row - 1, grams: val, percent: nil, updCalories: true)
                delegate.userInfoChanged(userInfo: delegate.userInfo)
                tableView.reloadData()
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    /*
    private func createSliderCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SliderCell {
        guard let userInfo = self.delegate?.userInfo else { return SliderCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? SliderCell {
            
            cell.updateHandler = { (value: Double, type: NutrientType) in
                guard var delegate = self.delegate else { return }
                
                switch type {
                case .Proteins:
                    delegate.userInfo.nutrition.setProteins(grams: nil, percent: value, updCalories: false)
                case .Carbs:
                    delegate.userInfo.nutrition.setCarbs(grams: nil, percent: value, updCalories: false)
                case .Fats:
                    delegate.userInfo.nutrition.setFats(grams: nil, percent: value, updCalories: false)
                default:
                    ()
                }
                
                self.tableView.reloadData()
            }
            
            let p: Double = userInfo.nutrition.proteins["percent"] ?? 0.0
            let c: Double = userInfo.nutrition.carbs["percent"] ?? 0.0
            let f: Double = userInfo.nutrition.fats["percent"] ?? 0.0
            
            switch indexPath.row {
            case 0:
                cell.setupView(title: PROTEINS, sliderValue: Float(userInfo.nutrition.proteins["percent"] ?? 0), nutrientType: .Proteins, max: 100 - c - f)
            case 1:
                cell.setupView(title: CARBS, sliderValue: Float(userInfo.nutrition.carbs["percent"] ?? 0), nutrientType: .Carbs, max: 100 - p - f)
            case 2:
                cell.setupView(title: FATS, sliderValue: Float(userInfo.nutrition.fats["percent"] ?? 0), nutrientType: .Fats, max: 100 - p - c)
            default: ()
            }
            
            return cell
        }
        
        return SliderCell()
    }
     */
}
