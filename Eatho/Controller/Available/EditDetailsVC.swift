//
//  EditDetailsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 16/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class EditDetailsVC: BaseVC {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let titles = ["Available", "Minimal portion", "Maximal portion", "Delta portion" ]
    var values = Array(repeating: 0.0, count: 4)
    var food: FoodItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func setupView(title: String, food: FoodItem) {
        titleLbl.text = title
        self.food = food
        
        var available = food.available ?? 0
        var min = food.dailyPortion.min != nil ? Double(food.dailyPortion.min!) : 0
        var max = food.dailyPortion.min != nil ? Double(food.dailyPortion.max!) : 0
        var delta = food.delta ?? 0
        
        if SettingsService.instance.userInfo.lbsMetrics {
            available = truncateDoubleTail(convertMetrics(g: available))
            min = truncateDoubleTail(convertMetrics(g: min))
            max = truncateDoubleTail(convertMetrics(g: max))
            delta = truncateDoubleTail(convertMetrics(g: delta))
        }
        
        values[0] = truncateDoubleTail(available)
        values[1] = truncateDoubleTail(min)
        values[2] = truncateDoubleTail(max)
        values[3] = truncateDoubleTail(delta)
    }
    
    @objc func tapHandler() {
        self.view.endEditing(false)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard var food = food else { return }
        
        if SettingsService.instance.userInfo.lbsMetrics {
            food.available = convertMetrics(lbs: values[0])
            food.dailyPortion.min = convertMetrics(lbs: values[1])
            food.dailyPortion.max = convertMetrics(lbs: values[2])
            food.delta = convertMetrics(lbs: values[3])
        } else {
            food.available = values[0]
            food.dailyPortion.min = values[1]
            food.dailyPortion.max = values[2]
            food.delta = values[3]
        }
        
        spinner.startAnimating()
        FoodService.instance.updateFood(food: food) {(_, error) in
            self.spinner.stopAnimating()
            if let error = error {
                self.showErrorAlert(title: "Update failed", message: error.message)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension EditDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "singleInputCell", for: indexPath) as? SingleInputCell else { return UITableViewCell() }
        
        cell.setupView(title: titles[indexPath.row], additionalDesc: SettingsService.instance.userInfo.lbsMetrics ? "lbs" : "g", placeholder: "0", text: values[indexPath.row] > 0 ? "\(values[indexPath.row])" : nil)
        cell.textField.keyboardType = .decimalPad
        
        cell.inpuFinishedDecimalHandler = {
            (_ val: Double) in
            self.values[indexPath.row] = val
        }
        
        return cell
    }
}
