//
//  AviailableVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 20/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AviailableVC: UIViewController {

    @IBOutlet weak var foodTable: UITableView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodTable.delegate = self
        foodTable.dataSource = self
        
        spinner.hidesWhenStopped = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NOTIF_FOOD_DATA_CHANGED, object: nil)
        
        configureRefreshControl()
        registerForPreviewing(with: self, sourceView: foodTable)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (AuthService.instance.isLoggedIn && DataService.instance.foods.count == 0) {
            loadData()
        }
    }
    
    // Configure
    
    func configureRefreshControl() {
        foodTable.refreshControl = UIRefreshControl()
        foodTable.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    
    // Handlers
    
    @objc private func loadData() {
        if AuthService.instance.isLoggedIn {
            
            if DataService.instance.foods.count == 0 {
                spinner.startAnimating()
            }
            
            DataService.instance.requestAvailableFoodItems(handler: { (success) in
                self.spinner.stopAnimating()
                self.foodTable.reloadData()
            })
        } else {
            DataService.instance.clearData()
            self.foodTable.reloadData()
        }
    }
    
    @objc private func updateData() {
        self.foodTable.reloadData()
    }
    
    @objc func handleRefresh() {
        DataService.instance.requestAvailableFoodItems(handler: { (success) in
            self.foodTable.reloadData()
            
            // Dismiss the refresh control.
            DispatchQueue.main.async {
                self.foodTable.refreshControl?.endRefreshing()
            }
        })
    }
    
    func openDetails(index: Int) {
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC else { return }
        
        present(detailsVC, animated: true, completion: nil)
        detailsVC.initData(food: DataService.instance.foods[index])
    }
    
    func openUpdateVC(index: Int) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "EditDetailsVC") as? EditDetailsVC else { return }
        
        present(editVC, animated: true, completion: nil)
        editVC.setupView(title: DataService.instance.foods[index].name!, id: DataService.instance.foods[index]._id!)
    }
    
    // Actions
    
    @IBAction func searchPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            if self.searchBarHeightConstraint.constant == 0 {
                self.searchBarHeightConstraint.constant = 56
            } else {
                self.searchBarHeightConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        }
    }
}


extension AviailableVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as? AvailableFoodCell {
            if (indexPath.row < DataService.instance.foods.count) {
                let food = DataService.instance.foods[indexPath.row]
                cell.updateViews(foodItem: food)
                return cell
            }
        }
        return AvailableFoodCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Remove") { (acion: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            DataService.instance.removeItem(index: indexPath.row)
            success(true)
        }
        removeAction.backgroundColor = EATHO_RED
        
        let revealDetailsAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Details") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.openDetails(index: indexPath.row)
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

extension AviailableVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = foodTable.indexPathForRow(at: location) else { return nil }
        guard let cell = foodTable.cellForRow(at: indexPath) else { return nil }
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC else { return nil }
        
        detailsVC.initData(food: DataService.instance.foods[indexPath.row])
        previewingContext.sourceRect = cell.contentView.frame
        
        return detailsVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
//        show(viewControllerToCommit, sender: self)
    }
}
