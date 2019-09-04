//
//  ComplementParamsModalVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 03/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class ComplementParamsModalVC: UIViewController {

    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var chartView: NutritionChartView!
    @IBOutlet weak var nutritionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
