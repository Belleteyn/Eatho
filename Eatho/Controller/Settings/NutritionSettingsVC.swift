//
//  NutritionSettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class NutritionSettingsVC: UIViewController {

    @IBOutlet weak var warningText: UILabel!
    @IBOutlet weak var consultWarningTitle: UILabel!
    @IBOutlet weak var consultWarningText: UILabel!
    @IBOutlet weak var correctWarningTitle: UILabel!
    @IBOutlet weak var correctWarningText: UILabel!
    @IBOutlet weak var correctRationTitle: UILabel!
    @IBOutlet weak var correcRationText: UILabel!
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningText.text = NUTRITION_WARNING_TEXT
        consultWarningTitle.text = NUTRITION_CONSULT_TITLE
        consultWarningText.text = NUTRITION_CONSULT_TEXT
        correctWarningTitle.text = NUTRITION_CORRECT_TITLE
        correctWarningText.text = NUTRITION_CORRECT_TEXT
        correctRationTitle.text = NUTRITION_NEEDS_TITLE
        correcRationText.text = NUTRITION_NEEDS_TEXT
    }

}
