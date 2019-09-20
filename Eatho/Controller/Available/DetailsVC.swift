//
//  DetailsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 14/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var chartView: NutritionChartView!
    @IBOutlet weak var fullInfoTableView: UITableView!
    
    var food: FoodItem?
    var foodInfo: Food?
    
    var userData = [Nutrient]()
    var macro = [Nutrient]()
    var minerals = [Nutrient]()
    var vitamins = [Nutrient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initData(food: FoodItem) {
        guard let foodInfo = food.food else { return }
        self.food = food
        titleLbl.text = foodInfo.name!
        
        userData = getUserData(food: food)
        macro = foodInfo.nutrition.getMacro(portion: food.delta)
        minerals = foodInfo.nutrition.getMinerals(portion: food.delta)
        vitamins = foodInfo.nutrition.getVitamins(portion: food.delta)
        
        chartView.initData(nutrition: foodInfo.nutrition)
    }
    
    func initData(food: Food) {
        self.foodInfo = food
        titleLbl.text = food.name!
        
        macro = food.nutrition.getMacro(portion: nil)
        minerals = food.nutrition.getMinerals(portion: nil)
        vitamins = food.nutrition.getVitamins(portion: nil)
        
        chartView.initData(nutrition: food.nutrition)
        
        editButton.isEnabled = false
    }
    
    @IBAction func editPressed(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "EditDetailsVC") as? EditDetailsVC else { return }
        present(vc, animated: true, completion: nil)
        vc.setupView(title: titleLbl.text!, food: food!)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getUserData(food: FoodItem) -> [Nutrient] {
        var available = food.available ?? 0
        var min = food.dailyPortion.min ?? 0
        var max = food.dailyPortion.max ?? 0
        var delta = food.delta ?? 0
        var measureLabelText = "g"
        
        if SettingsService.instance.userInfo.lbsMetrics {
            available = truncateDoubleTail(convertMetrics(g: available))
            min = truncateDoubleTail(convertMetrics(g: min))
            max = truncateDoubleTail(convertMetrics(g: max))
            delta = truncateDoubleTail(convertMetrics(g: delta))
            measureLabelText = "lbs"
        } else {
            available = truncateDoubleTail(available)
            min = truncateDoubleTail(min)
            max = truncateDoubleTail(max)
            delta = truncateDoubleTail(delta)
        }
        
        var data = [Nutrient]()
        data.append(Nutrient(name: "Available", perPorition: nil, per100g: available, measure: measureLabelText, type: .main))
        data.append(Nutrient(name: "Daily min portion", perPorition: nil, per100g: min, measure: measureLabelText, type: .main))
        data.append(Nutrient(name: "Daily max portion", perPorition: nil, per100g: max, measure: measureLabelText, type: .main))
        data.append(Nutrient(name: "Delta portion", perPorition: nil, per100g: delta, measure: measureLabelText, type: .main))
        
        return data
    }
}


extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if userData.isEmpty {
            return 1 + (minerals.count == 0 ? 0 : 1) + (vitamins.count == 0 ? 0 : 1)
        } else {
            return 2 + (minerals.count == 0 ? 0 : 1) + (vitamins.count == 0 ? 0 : 1)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sect = section
        if userData.isEmpty {
            sect = section + 1
        }
        
        switch sect {
        case 0:
            return userData.count
        case 1:
            return macro.count
        case 2:
            return minerals.count
        case 3:
            return vitamins.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var sect = indexPath.section
        if userData.isEmpty {
            sect = indexPath.section + 1
        }
        
        switch sect {
        case 0:
            if let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
                cell.initData(nutrient: userData[indexPath.row])
                return cell
            }
        case 1:
            if macro[indexPath.row].type == .main {
                if let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
                    cell.initData(nutrient: macro[indexPath.row])
                    return cell
                }
            } else {
                if let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: "foodDetailsEnclosedCell", for: indexPath) as? FoodDetailsCell {
                    cell.initData(nutrient: macro[indexPath.row])
                    return cell
                }
            }
        case 2:
            if let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
                cell.initData(nutrient: minerals[indexPath.row])
                return cell
            }
        case 3:
            if let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
                cell.initData(nutrient: vitamins[indexPath.row])
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sect = section
        if userData.isEmpty {
            sect = section + 1
        }
        
        switch sect {
        case 0:
            return "User info"
        case 1:
            return "Nutrition facts"
        case 2:
            return "Minerals"
        case 3:
            return "Vitamins"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var sect = indexPath.section
        if userData.isEmpty {
            sect = indexPath.section + 1
        }
        
        if sect == 1 {
            if macro[indexPath.row].type == .enclosed {
                return 33
            }
        }
        return 43
    }
}
