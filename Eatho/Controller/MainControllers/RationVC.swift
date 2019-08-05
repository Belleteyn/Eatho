//
//  RationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var rationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rationTableView.delegate = self
        rationTableView.dataSource = self
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(authChangedHandle), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChangedHandle), name: NOTIF_RATION_DATA_CHANGED, object: nil)
        
        RationService.instance.requestRation { (success) in
            self.rationTableView.reloadData()
        }
    }
    
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RationService.instance.ration.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "rationFoodCell") as? RationFoodCell {
            cell.updateViews(foodItem: RationService.instance.ration[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // handlers
    @objc func authChangedHandle() {
        if !AuthService.instance.isLoggedIn {
            RationService.instance.clearData()
            self.rationTableView.reloadData()
        }
    }
    
    @objc func dataChangedHandle() {
        rationTableView.reloadData()
    }
}
