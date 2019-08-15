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
        if let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
            if indexPath.section == 0 {
                cell.initData(nutrient: macro[indexPath.row])
            } else {
                cell.initData(nutrient: micro[indexPath.row])
            }
            return cell
        }
        
        if let cell = fullInfoTableView.dequeueReusableCell(withIdentifier: "foodDetailsEnclosedCell", for: indexPath) as? FoodDetailsCell {
            if indexPath.section == 0 {
                cell.initData(nutrient: macro[indexPath.row])
            } else {
                cell.initData(nutrient: micro[indexPath.row])
            }
            return cell
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
}
