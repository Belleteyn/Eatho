//
//  CreationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 28/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class CreationVC: UIViewController {

    // Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var typeTxt: UITextField!
    @IBOutlet weak var caloriesTxt: UITextField!
    @IBOutlet weak var carbsTxt: UITextField!
    @IBOutlet weak var proteinsTxt: UITextField!
    @IBOutlet weak var fatsTxt: UITextField!
    @IBOutlet weak var giTxt: UITextField!
    @IBOutlet weak var availableTxt: UITextField!
    @IBOutlet weak var minTxt: UITextField!
    @IBOutlet weak var maxTxt: UITextField!
    @IBOutlet weak var preferredTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Actions
    @IBAction func saveClicked(_ sender: Any) {
        guard let name = nameTxt.text, nameTxt.text != "" else { return }
        guard let calories = caloriesTxt.text, caloriesTxt.text != "" else { return }
        guard let carbs = carbsTxt.text, carbsTxt.text != "" else { return }
        guard let proteins = proteinsTxt.text, proteinsTxt.text != "" else { return }
        guard let fats = fatsTxt.text, fatsTxt.text != "" else { return }
        
        let type = typeTxt.text ?? ""
        let gi = giTxt.text ?? "0"
        let available = availableTxt.text ?? "0"
        let min = minTxt.text ?? "0"
        let max = maxTxt.text ?? "0"
        let preferred = preferredTxt.text ?? "0"
        
        //todo check validness
        //todo send info, close view
    }
}
