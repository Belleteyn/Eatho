//
//  RationComplementVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 03/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationComplementVC: FoodVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodTable.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NOTIF_RATION_DATA_CHANGED, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        foodTable.reloadData()
    }
    
    func presentModalView(food: FoodItem) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "complementParamsModalVC") as? ComplementParamsModalVC else { return }
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .custom
        
        self.navigationController?.present(navController, animated: true) {
            vc.setupView(foodItem: food)
        }
    }
    
    @objc func refresh() {
        foodTable.reloadData()
    }
}

extension RationComplementVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodService.instance.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RationInsertionFoodCell") as? RationInsertionFoodCell {
            if (indexPath.row < FoodService.instance.foods.count) {
                let food = FoodService.instance.foods[indexPath.row]
                cell.updateViews(foodItem: food, removeHandler: { (id) in
                    RationService.instance.removeItem(id: id, completion: { (_, error) in
                        if let error = error {
                            self.showErrorAlert(title: ERROR_TITLE_RATION_UPDATE_FAILED, message: error.message)
                        }
                    })
                }) { (foodItem) in
                    self.presentModalView(food: foodItem)
                }
                
                return cell
            }
        }
        return RationInsertionFoodCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Remove") { (acion: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            FoodService.instance.removeItem(index: indexPath.row, handler: { (localRemoveSucceeded, error) in
                success(localRemoveSucceeded)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }, requestHandler: { (remoteRemoveSucceeded, error) in
                //todo show error
                super.loadData()
            })
        }
        removeAction.backgroundColor = EATHO_RED
        
        let revealDetailsAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Details") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            super.openDetails(index: indexPath.row)
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

