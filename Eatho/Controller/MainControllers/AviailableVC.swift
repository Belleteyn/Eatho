//
//  AviailableVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 20/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AviailableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var foodTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodTable.delegate = self
        foodTable.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NOTIF_FOOD_DATA_CHANGED, object: nil)
        
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if AuthService.instance.isLoggedIn {
            DataService.instance.uploadData()
        }
    }
    
    // handlers
    @objc private func loadData() {
        if AuthService.instance.isLoggedIn {
            DataService.instance.requestAvailableFoodItems(handler: { (success) in })
        } else {
            DataService.instance.clearData()
            self.foodTable.reloadData()
        }
    }
    
    @objc private func updateData() {
        self.foodTable.reloadData()
    }
    
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as? FoodCell {
            let food = DataService.instance.foods[indexPath.row]
            cell.updateViews(foodItem: food)
            return cell
        } else {
            return FoodCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Remove") { (acion: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            DataService.instance.removeItem(index: indexPath.row)
            success(true)
        }
        removeAction.backgroundColor = EATHO_RED
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
