//
//  FoodVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class FoodVC: BaseVC {

    @IBOutlet weak var foodTable: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTable.delegate = self
        
        spinner.hidesWhenStopped = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NOTIF_LOGGED_IN, object: nil)
    }
    
    @objc func loadData() {
        if FoodService.instance.foods.count == 0 {
            spinner.startAnimating()
        }
        
        FoodService.instance.get(completion: { (_, error) in
            self.spinner.stopAnimating()
            
            if let error = error {
                self.showErrorAlert(title: ERROR_MSG_FOOD_GET_FAILED, message: error.message)
                return
            }
            
            self.reloadTable()
        })
    }
    
    func reloadTable() {
        foodTable.reloadData()
        foodTable.isHidden = (FoodService.instance.foods.count == 0)
    }
    
    func openDetails(foodItem: FoodItem) {
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC else { return }
        
        present(detailsVC, animated: true, completion: nil)
        detailsVC.initData(food: foodItem)
    }
    
    func openDetails(food: Food) {
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC else { return }

        if let vc = presentedViewController {
            vc.present(detailsVC, animated: true, completion: nil)
        } else {
            present(detailsVC, animated: true, completion: nil)
        }
        
        detailsVC.initData(food: food)
    }
    
    func openUpdateVC(index: Int, delegate: FoodItemDelegate?) {
        guard let editVC = storyboard?.instantiateViewController(withIdentifier: "EditDetailsVC") as? EditDetailsVC else { return }
        
        editVC.delegate = delegate
        present(editVC, animated: true, completion: nil)
        
        let foodItem = FoodService.instance.foods[index]
        guard let food = foodItem.food, let name = food.name else { return }
        editVC.setupView(title: name, food: foodItem, index: index)
    }
}

extension FoodVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}
