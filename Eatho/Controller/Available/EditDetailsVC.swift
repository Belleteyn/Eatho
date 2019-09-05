//
//  EditDetailsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 16/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class EditDetailsVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var availableTxtField: UITextField!
    @IBOutlet weak var minTxtField: UITextField!
    @IBOutlet weak var maxTxtField: UITextField!
    @IBOutlet weak var deltaTxtField: UITextField!
    
    var food: FoodItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
    }
    
    func setupView(title: String, food: FoodItem) {
        titleLbl.text = title
        self.food = food
        
        availableTxtField.text = "\(food.available ?? 0)"
        minTxtField.text = "\(food.dailyPortion.min ?? 0)"
        maxTxtField.text = "\(food.dailyPortion.max ?? 0)"
        deltaTxtField.text = "\(food.delta ?? 0)"
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if let availText = availableTxtField.text {
            if let availVal = Double(availText) {
                food?.available = availVal
            }
        }
        if let minText = minTxtField.text {
            if let minVal = Int(minText) {
                food?.dailyPortion.min = minVal
            }
        }
        if let maxText = maxTxtField.text {
            if let maxVal = Int(maxText) {
                food?.dailyPortion.max = maxVal
            }
        }
        if let deltaText = deltaTxtField.text {
            if let deltaVal = Double(deltaText) {
                food?.delta = deltaVal
            }
        }
        
        spinner.startAnimating()
        FoodService.instance.updateFood(food: food!) {(success, error) in
            self.spinner.stopAnimating()
            if (success) {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("failed to update user data")
            }
        }
    }
}
