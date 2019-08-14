//
//  RationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var rationTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var nutrientRelativityView: NutrientsRelativityView!
    
    @IBOutlet weak var rationCaloriesLbl: UILabel!
    @IBOutlet weak var expectedCaloriesLbl: UILabel!
    @IBOutlet weak var carbsLbl: UILabel!
    @IBOutlet weak var fatsLbl: UILabel!
    @IBOutlet weak var proteinsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rationTableView.delegate = self
        rationTableView.dataSource = self
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(authChangedHandle), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChangedHandle), name: NOTIF_RATION_DATA_CHANGED, object: nil)
        
        RationService.instance.requestRation { (success) in
            self.updateView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //to keep updated version in case if user changed calories in settings
        expectedCaloriesLbl.text = "of \(Int(round(SettingsService.instance.userInfo.nutrition.calories))) kcal"
    }
    
    func updateView() {
        rationTableView.reloadData()
        
        rationCaloriesLbl.text = "\(Int(round(RationService.instance.calories))) kcal"
        carbsLbl.text = "\(Int(round(RationService.instance.carbs))) g"
        fatsLbl.text = "\(Int(round(RationService.instance.fats))) g"
        proteinsLbl.text = "\(Int(round(RationService.instance.proteins))) g"
        
        let carbsPercent = (RationService.instance.carbs * 4.1 / RationService.instance.calories)
        let proteinsPercent = (RationService.instance.proteins * 4.1 / RationService.instance.calories)
        let fatsPercent = (RationService.instance.fats * 9.29 / RationService.instance.calories)
        
        nutrientRelativityView.updateView(proteinsPercent: proteinsPercent, carbsPercent: carbsPercent, fatsPercent: fatsPercent)
    }
    
    // handlers
    @objc func authChangedHandle() {
        if !AuthService.instance.isLoggedIn {
            RationService.instance.clearData()
            self.rationTableView.reloadData()
        }
    }
    
    @objc func dataChangedHandle() {
        updateView()
    }
}

extension RationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RationService.instance.ration.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "rationFoodCell") as? RationFoodCell {
            if (indexPath.row < RationService.instance.ration.count) {
                cell.updateViews(foodItem: RationService.instance.ration[indexPath.row])
                return cell
            }
        }
        return RationFoodCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Remove") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            RationService.instance.removeItem(index: indexPath.row)
            success(true)
            self.rationTableView.reloadData()
        }
        removeAction.backgroundColor = EATHO_RED
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
