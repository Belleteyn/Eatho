//
//  RationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var rationTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var rationInfoView: RationNutrientsView!
    @IBOutlet weak var rationInfoViewHeight: NSLayoutConstraint!
    
    var rationInfoViewExpandedState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rationTableView.delegate = self
        rationTableView.dataSource = self
        
        spinner.hidesWhenStopped = true
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(authChangedHandle), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChangedHandle), name: NOTIF_RATION_DATA_CHANGED, object: nil)
        
        if RationService.instance.diary.count == 0 {
            RationService.instance.requestRation { (success, error) in
                self.updateView()
            }
        }
        
        let rationViewTapHandler = UITapGestureRecognizer(target: self, action: #selector(rationViewTapHandle))
        rationInfoView.addGestureRecognizer(rationViewTapHandler)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //to keep updated version in case if user changed calories in settings
        rationInfoView.setupUserData()
        updateView()
    }
    
    func updateView() {
        if let date = RationService.instance.currentDate {
            guard let formattedDate = EathoDateFormatter.instance.format(isoDate: date) else { return }
            rationTableView.reloadData()
            rationInfoView.setupNutrition()
            navigationItem.title = formattedDate
        }
    }
    
    // handlers
    @objc func authChangedHandle() {
        if !AuthService.instance.isLoggedIn {
            RationService.instance.resetData()
            self.rationTableView.reloadData()
        }
    }
    
    @objc func dataChangedHandle() {
        updateView()
    }
    
    @objc func rationViewTapHandle() {
        rationInfoViewExpandedState = !rationInfoViewExpandedState
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.easeInOut) {
            if self.rationInfoViewExpandedState {
                self.rationInfoViewHeight.constant = 230
            } else {
                self.rationInfoViewHeight.constant = 60
            }
            self.rationInfoView.changeMode(expanded: self.rationInfoViewExpandedState)
            self.rationInfoView.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}

extension RationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ration = RationService.instance.currentRation else { return 0 }
        return ration.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "rationFoodCell") as? RationFoodCell {
            guard let ration = RationService.instance.currentRation else { return RationFoodCell() }
            if (indexPath.row < ration.count) {
                cell.updateViews(foodItem: ration[indexPath.row])
                return cell
            }
        }
        return RationFoodCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Remove") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            RationService.instance.removeItem(index: indexPath.row) { (success, error) in
                if let error = error {
                    print(error)
                }
            }
            
            success(true)
            self.rationTableView.reloadData()
        }
        removeAction.backgroundColor = EATHO_RED
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
