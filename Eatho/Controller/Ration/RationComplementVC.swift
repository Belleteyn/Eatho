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
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentModalView(_:)), name: NOTIF_PRESENT_RATION_COMPLEMENT_MODAL, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        foodTable.reloadData()
    }
    
    @objc func presentModalView(_ notification: Notification) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "complementParamsModalVC") else { return }
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .custom
        
        self.navigationController?.present(navController, animated: true, completion: nil)
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
                cell.updateViews(foodItem: food)
                return cell
            }
        }
        return RationInsertionFoodCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Remove") { (acion: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            FoodService.instance.removeItem(index: indexPath.row, handler: { (localRemoveSucceeded) in
                success(localRemoveSucceeded)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }, requestHandler: { (remoteRemoveSucceeded) in
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

