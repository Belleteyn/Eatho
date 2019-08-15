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
    @IBOutlet weak var fullInfoTableView: UITableView!
    
    var macro = [Nutrient]()
    var micro = [Nutrient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initData(food: FoodItem) {
        nameLbl.text = food.name
        icon.image = UIImage(named: food.icon)
        
        macro = food.nutrition.getMacro(portion: food.portion ?? 0)
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return macro.count
        case 1:
            return micro.count
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
                cell.initData(nutrient: micro[indexPath.row])
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
            return "Macronutriens"
        case 1:
            return "Micronutrients"
        default:
            return "unknown section"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if macro[indexPath.row].type == .enclosed {
                return 33
            }
        }
        return 45
    }
}
