//
//  ComplementParamsModalVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 03/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class ComplementParamsModalVC: BaseVC {

    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var input: UITextView!
    @IBOutlet weak var chartView: NutritionChartView!
    @IBOutlet weak var nutritionTableView: UITableView!
    @IBOutlet weak var buttonStack: UIStackView!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var chartViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var food: FoodItem?
    var portion = 0.0
    
    var macro = [Nutrient]()
    var minerals = [Nutrient]()
    var vitamins = [Nutrient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        
        viewHeight.constant = view.bounds.height - 200
        
        nutritionTableView.dataSource = self
        nutritionTableView.delegate = self
        
        input.delegate = self
        input.textColor = LIGHT_TEXT_COLOR
        
        let tapHandle = UITapGestureRecognizer(target: self, action: #selector(finishEditing))
        self.view.addGestureRecognizer(tapHandle)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setupView(foodItem: FoodItem) {
        guard let food = foodItem.food else { return }
        self.food = foodItem
        
        name.text = food.name!
        typeIcon.image = UIImage(named: food.icon)
        
        chartView.initData(nutrition: food.nutrition)
        updateTable(portion: 0)
    }
    
    private func updateTable(portion: Double) {
        guard let food = food?.food else { return }
        
        macro = food.nutrition.getMacro(portion: portion)
        minerals = food.nutrition.getMinerals(portion: portion)
        vitamins = food.nutrition.getVitamins(portion: portion)
        nutritionTableView.reloadData()
    }
    
    @objc func finishEditing() {
        view.endEditing(true)
    }
    
    @objc func keyboardHandler(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let startFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = startFrame.minY - endFrame.minY
        
        UIView.animate(withDuration: duration) {
            if self.chartViewHeight.constant == 0 {
                self.chartViewHeight.constant = 150
                self.viewHeight.constant -= (deltaY + 85)
                self.buttonStackHeight.constant = 0
                self.buttonStack.isHidden = true
            } else {
                self.chartViewHeight.constant = 0
                self.viewHeight.constant -= (deltaY - 85)
                self.buttonStackHeight.constant = 40
                self.buttonStack.isHidden = false
            }
            
            self.chartView.layoutIfNeeded()
            self.buttonStack.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        spinner.startAnimating()
        view.endEditing(true)
        
        food?.portion = portion
        food?.delta = portion
        RationService.instance.addToRation(food: food!) { (success, error) in
            self.spinner.stopAnimating()
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension ComplementParamsModalVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "weight" {
            textView.text = ""
            textView.textColor = TEXT_COLOR
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.textColor = LIGHT_TEXT_COLOR
            textView.text = "weight"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 4 {
            textView.text = "\(textView.text.dropLast(1))"
            return
        }
        
        guard let portion = Double(textView.text!) else { return }
        self.portion = portion
        updateTable(portion: portion)
    }
}

extension ComplementParamsModalVC: UITableViewDelegate, UITableViewDataSource {
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
                if let cell = tableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
                    cell.initData(nutrient: macro[indexPath.row])
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "foodDetailsEnclosedCell", for: indexPath) as? FoodDetailsCell {
                    cell.initData(nutrient: macro[indexPath.row])
                    return cell
                }
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
                cell.initData(nutrient: minerals[indexPath.row])
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "foodDetailsCell", for: indexPath) as? FoodDetailsCell {
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
