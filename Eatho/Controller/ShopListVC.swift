//
//  ShopListVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class ShopListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    // Outlets
    @IBOutlet weak var shopListTabBar: UITabBar!
    @IBOutlet weak var shopListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shopListTableView.delegate = self
        shopListTableView.dataSource = self
        
        shopListTabBar.delegate = self
        shopListTabBar.selectedItem = shopListTabBar.items?.first
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        shopListTableView.reloadData()
    }
    
    // table view
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
}
