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
        
        navigationItem.largeTitleDisplayMode = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NOTIF_FOOD_DATA_CHANGED, object: nil)
        
        configureRefreshControl()
//        registerForPreviewing(with: self, sourceView: foodTable)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (AuthService.instance.isLoggedIn && DataService.instance.foods.count == 0) {
            loadData()
        }
    }
    
    
    // Handlers
    
    @objc private func loadData() {
        if AuthService.instance.isLoggedIn {
            
            if DataService.instance.foods.count == 0 {
                spinner.startAnimating()
            }
            
            DataService.instance.requestAvailableFoodItems(handler: { (success) in
                super.foods = DataService.instance.foods
                self.spinner.stopAnimating()
                self.foodTable!.reloadData()
            })
        } else {
            DataService.instance.clearData()
            self.foodTable!.reloadData()
        }
    }
    
    @objc private func updateData() {
        self.foodTable.reloadData()
    }
    
    func openUpdateVC(index: Int) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "EditDetailsVC") as? EditDetailsVC else { return }
        
        present(editVC, animated: true, completion: nil)
        editVC.setupView(title: DataService.instance.foods[index].name!, food: DataService.instance.foods[index])
    }
}


extension AviailableVC {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Remove") { (acion: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            DataService.instance.removeItem(index: indexPath.row)
            success(true)
        }
        removeAction.backgroundColor = EATHO_RED
        
        let revealDetailsAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Details") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            super.openDetails(index: indexPath.row, usingUserData: true)
            success(true)
        }
        
        let updateAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Update") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.openUpdateVC(index: indexPath.row)
            success(true)
        }
        updateAction.backgroundColor = EATHO_YELLOW
        
        return UISwipeActionsConfiguration(actions: [removeAction, updateAction, revealDetailsAction])
    }
}

