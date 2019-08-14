//
//  ShopListVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class ShopListVC: UIViewController {

    // Outlets
    @IBOutlet weak var shopListTabBar: UITabBar!
    @IBOutlet weak var shopListTableView: UITableView!
    @IBOutlet weak var insertionTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // table view
        shopListTableView.delegate = self
        shopListTableView.dataSource = self
        
        // tab bar
        shopListTabBar.delegate = self
        shopListTabBar.selectedItem = shopListTabBar.items?.first
        
        // gestures
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(authDataChanged), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdateHandle), name: NOTIF_SHOPPING_LIST_DATA_CHAGNED, object: nil)
        
        // init data
        ShopListService.instance.requestData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ShopListService.instance.uploadData()
    }
    
    // handlers
    @objc func tapHandle() {
        view.endEditing(true)
    }
    
    @objc func dataUpdateHandle() {
        shopListTableView.reloadData()
    }
    
    @objc func authDataChanged() {
        if AuthService.instance.isLoggedIn {
            ShopListService.instance.requestData()
        } else {
            ShopListService.instance.clearData()
        }
        shopListTableView.reloadData()
    }
    
    // Actions
    @IBAction func insertionStringHandle(_ sender: Any) {
        if (insertionTxt.text != "") {
            ShopListService.instance.addItem(name: insertionTxt.text!)
            shopListTableView.reloadData()
            insertionTxt.text = ""
        }
    }
}

extension ShopListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shopListTabBar.selectedItem == shopListTabBar.items?.first {
            return ShopListService.instance.list.count
        } else {
            return ShopListService.instance.mostRecentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shopListTabBar.selectedItem == shopListTabBar.items?.first {
            
            if let listCell = shopListTableView.dequeueReusableCell(withIdentifier: "shoppingListCell") as? ShoppingListCell {
                let list = ShopListService.instance.list
                let keys = list.keys
                let values = list.values
                let index = keys.index(list.startIndex, offsetBy: indexPath.row)
                listCell.updateView(name: keys[index], selectionState: values[index])
                return listCell
            }
        } else {
            if let mostRecentCell = shopListTableView.dequeueReusableCell(withIdentifier: "recentPurchasesCell") as? RecentPurchasesCell {
                mostRecentCell.updateView(name: ShopListService.instance.mostRecentList[indexPath.row])
                return mostRecentCell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trashAction = UIContextualAction(style: .normal, title: "Remove") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            if self.shopListTabBar.selectedItem == self.shopListTabBar.items?.first {
                let list = ShopListService.instance.list
                let index = list.index(list.startIndex, offsetBy: indexPath.row)
                ShopListService.instance.removeItemFromShopList(index: index)
            } else {
                ShopListService.instance.removeItemFromRecent(index: indexPath.row)
            }
            
            self.shopListTableView.reloadData()
            success(true)
        }
        trashAction.backgroundColor = EATHO_RED
        
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
}

extension ShopListVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        shopListTableView.reloadData()
        UIView.animate(withDuration: 0.3, animations:  {
            self.insertionTxt.isHidden = (self.shopListTabBar.selectedItem != self.shopListTabBar.items?.first)
            self.view.layoutIfNeeded()
        })
    }
}
