//
//  RationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var rationTableView: UITableView!
    
    @IBOutlet weak var carbsView: UIView!
    @IBOutlet weak var fatsView: UIView!
    @IBOutlet weak var proteinsView: UIView!
    
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
    
    func updateView() {
        rationTableView.reloadData()
        
        //TODO: update top view data
    }
    
    // table view
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
