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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTable.delegate = self
        
        spinner.hidesWhenStopped = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
    }
    
    @objc func loadData() {
        if AuthService.instance.isLoggedIn {
            
            if FoodService.instance.foods.count == 0 {
                spinner.startAnimating()
            }
            
            FoodService.instance.getFood(handler: { (success) in
                self.spinner.stopAnimating()
                self.reloadTable()
            })
        } else {
            FoodService.instance.clearData()
            self.reloadTable()
        }
    }
    
    func reloadTable() {
        foodTable.reloadData()
        foodTable.isHidden = (FoodService.instance.foods.count == 0)
    }
    
    func openDetails(index: Int) {
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC else { return }
        
        present(detailsVC, animated: true, completion: nil)
        detailsVC.initData(food: FoodService.instance.foods[index])
    }
    
    func openUpdateVC(index: Int) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "EditDetailsVC") as? EditDetailsVC else { return }
        
        present(editVC, animated: true, completion: nil)
        editVC.setupView(title: FoodService.instance.foods[index].food!.name!, food: FoodService.instance.foods[index])
    }
}

extension FoodVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}
