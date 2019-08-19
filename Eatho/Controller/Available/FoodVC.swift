//
//  FoodVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class FoodVC: UIViewController {

    @IBOutlet weak var foodTable: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var foods = [FoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodTable.delegate = self
        foodTable.dataSource = self
        
        spinner.hidesWhenStopped = true
    }

    func openDetails(index: Int, usingUserData: Bool) {
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC else { return }
        
        present(detailsVC, animated: true, completion: nil)
        detailsVC.initData(food: DataService.instance.foods[index], withUserData: usingUserData)
    }
    
    // Configure
    
    func configureRefreshControl() {
        foodTable.refreshControl = UIRefreshControl()
        foodTable.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    // Handlers
    
    @objc func handleRefresh() {
        DataService.instance.requestAvailableFoodItems(handler: { (success) in
            self.foodTable.reloadData()
            
            // Dismiss the refresh control.
            DispatchQueue.main.async {
                self.foodTable.refreshControl?.endRefreshing()
            }
        })
    }
}

extension FoodVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as? AvailableFoodCell {
            if (indexPath.row < foods.count) {
                let food = foods[indexPath.row]
                cell.updateViews(foodItem: food)
                return cell
            }
        }
        return AvailableFoodCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
