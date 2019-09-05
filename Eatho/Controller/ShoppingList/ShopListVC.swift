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
    @IBOutlet weak var insertionTxtHeight: NSLayoutConstraint!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // table view
        shopListTableView.delegate = self
        shopListTableView.dataSource = self
        
        // tab bar
        shopListTabBar.delegate = self
        shopListTabBar.selectedItem = shopListTabBar.items?.first
        
        // text input
        insertionTxt.delegate = self
        
        // spinner
        spinner.hidesWhenStopped = true
        
        // gestures
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(authDataChanged), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        
        // init data
        ShopListService.instance.requestData { (_, _)  in
            self.shopListTableView.reloadData()
        }
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
            ShopListService.instance.requestData { (_, _) in
                self.shopListTableView.reloadData()
            }
        } else {
            ShopListService.instance.clearData()
            shopListTableView.reloadData()
        }
    }
}

extension ShopListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shopListTabBar.selectedItem == shopListTabBar.items?.first {
            return ShopListService.instance.shoppingList.count
        } else {
            return ShopListService.instance.mostRecentList.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if shopListTabBar.selectedItem == shopListTabBar.items?.first {
            return "shopping list"
        } else {
            return "recent purchases"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shopListTabBar.selectedItem == shopListTabBar.items?.first {
            if let listCell = shopListTableView.dequeueReusableCell(withIdentifier: "shoppingListCell") as? ShoppingListCell {
                let list = ShopListService.instance.shoppingList
                listCell.updateView(name: list[indexPath.row].key, selectionState: list[indexPath.row].value)
                listCell.selectionStyle = UITableViewCell.SelectionStyle.none
                return listCell
            }
        } else {
            if let mostRecentCell = shopListTableView.dequeueReusableCell(withIdentifier: "recentPurchasesCell") as? RecentPurchasesCell {
                mostRecentCell.updateView(name: ShopListService.instance.mostRecentList[indexPath.row])
                
                let selectedBrndView = UIView()
                selectedBrndView.backgroundColor = EATHO_YELLOW_OPACITY50
                mostRecentCell.selectedBackgroundView = selectedBrndView
                return mostRecentCell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trashAction = UIContextualAction(style: .destructive, title: "Remove") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            if self.shopListTabBar.selectedItem == self.shopListTabBar.items?.first {
                self.spinner.startAnimating()
                
                ShopListService.instance.removeItemFromShopList(index: indexPath.row) { (updSuccess, error) in
                    self.spinner.stopAnimating()
                    if !updSuccess {
                        print("shopping list error: failed to remove item to shopping list")
                    }
                }
            } else {
                self.spinner.startAnimating()
                ShopListService.instance.removeItemFromRecent(index: indexPath.row) { (updSuccess, error) in
                    self.spinner.stopAnimating()
                    if !updSuccess {
                        print("shopping list error: failed to remove item from recent purchases")
                    }
                }
            }
            
            success(true)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        trashAction.backgroundColor = EATHO_RED
        
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shopListTabBar.selectedItem == shopListTabBar.items?.last {
            ShopListService.instance.moveItemFromRecentToShopList(recentIndex: indexPath.row) { (success, error) in
                if !success {
                    print("shopping list error: failed to move item from recent to shopping list")
                }
                tableView.reloadData()
            }
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        }
    }
}

extension ShopListVC: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        shopListTableView.reloadData()
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        UIView.animate(withDuration: 0.4, animations:  {
            let hide = (self.shopListTabBar.selectedItem != self.shopListTabBar.items?.first)
            if hide {
                self.insertionTxtHeight.constant = 0
            } else {
                self.insertionTxtHeight.constant = 72
            }
            
            self.view.layoutIfNeeded()
        })
    }
}

extension ShopListVC: UITextFieldDelegate {
    func processText(_ textField: UITextField) {
        guard let name = textField.text else { return }
        if name == "" {
            return
        }
        
        let service = ShopListService.instance
        
        spinner.startAnimating()
        service.addItem(name: name) { (success, error) in
            if !success {
                print("shopping list error: failed to add item to shopping list")
            }
            self.spinner.stopAnimating()
            textField.text = ""
        }
        
        if let index = service.shoppingList.firstIndex(where: { $0.0 == name } ) {
            shopListTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        processText(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processText(textField)
//        view.endEditing(false)
        return true
    }
}
