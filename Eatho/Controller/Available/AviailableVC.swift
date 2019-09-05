//
//  AviailableVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 20/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AviailableVC: FoodVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTable.dataSource = self
        
        navigationItem.largeTitleDisplayMode = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NOTIF_FOOD_DATA_CHANGED, object: nil)
        
        configureRefreshControl()
//        registerForPreviewing(with: self, sourceView: foodTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (AuthService.instance.isLoggedIn && FoodService.instance.foods.count == 0) {
            super.loadData()
        }
        
        super.reloadTable()
    }
    
    // Configure
    
    func configureRefreshControl() {
        foodTable.refreshControl = UIRefreshControl()
        foodTable.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    // Handlers
    
    @objc func handleRefresh() {
        FoodService.instance.getFood(handler: { (success, error) in
            self.reloadTable()
            
            // Dismiss the refresh control.
            DispatchQueue.main.async {
                self.foodTable.refreshControl?.endRefreshing()
            }
        })
    }
    
    @objc private func updateData(_ notification: Notification) {
        if let info = notification.userInfo {
            self.foodTable.reloadRows(at: [IndexPath(row: info["index"] as! Int, section: 0)], with: .automatic)
        } else {
            self.reloadTable()
        }
    }
}


extension AviailableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodService.instance.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as? AvailableFoodCell {
            if (indexPath.row < FoodService.instance.foods.count) {
                let food = FoodService.instance.foods[indexPath.row]
                cell.updateViews(foodItem: food)
                return cell
            }
        }
        return AvailableFoodCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Remove") { (acion: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            FoodService.instance.removeItem(index: indexPath.row, handler: { (localRemoveSucceeded, error) in
                success(localRemoveSucceeded)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }, requestHandler: { (remoteRemoveSucceeded, error) in
                //todo show error
                self.loadData()
            })
        }
        removeAction.backgroundColor = EATHO_RED
        
        let revealDetailsAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Details") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.openDetails(index: indexPath.row)
            success(true)
        }
        
        let updateAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Update") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            super.openUpdateVC(index: indexPath.row)
            success(true)
        }
        updateAction.backgroundColor = EATHO_YELLOW
        
        return UISwipeActionsConfiguration(actions: [removeAction, updateAction, revealDetailsAction])
    }
}

