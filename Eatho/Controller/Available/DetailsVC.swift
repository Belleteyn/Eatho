//
//  DetailsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 14/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var chartView: NutritionChartView!
    @IBOutlet weak var fullInfoTableView: UITableView!
    
    var macro = [Nutrient]()
    var minerals = [Nutrient]()
    var vitamins = [Nutrient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initData(food: FoodItem) {
        nameLbl.text = food.name
        icon.image = UIImage(named: food.icon)
        
        macro = food.nutrition.getMacro(portion: food.delta ?? 0)
        minerals = food.nutrition.getMinerals(portion: food.delta ?? 0)
        vitamins = food.nutrition.getVitamins(portion: food.delta ?? 0)
        
        chartView.initData(nutrition: food.nutrition)
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (minerals.count == 0 ? 0 : 1) + (vitamins.count == 0 ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return macro.count
        case 1:
            return minerals.count
        case 2:
            return vitamins.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
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
        case 1:
            if let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
                cell.initData(nutrient: minerals[indexPath.row])
                return cell
            }
        case 2:
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
        switch section {
        case 0:
            return "Nutrition facts"
        case 1:
            return "Minerals"
        case 2:
            return "Vitamins"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if macro[indexPath.row].type == .enclosed {
                return 33
            }
        }
        return 43
    }
}
