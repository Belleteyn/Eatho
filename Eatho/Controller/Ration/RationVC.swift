//
//  RationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationVC: BaseVC {
    
    // Outlets
    @IBOutlet weak var rationTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var rationInfoView: RationNutrientsView!
    @IBOutlet weak var rationInfoViewHeight: NSLayoutConstraint!
    
    var rationInfoViewExpandedState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabChangeDelegate = self
        
        rationTableView.delegate = self
        rationTableView.dataSource = self
        
        spinner.hidesWhenStopped = true
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(dataChangedHandle), name: NOTIF_RATION_DATA_CHANGED, object: nil)
        
        if RationService.instance.diary.count == 0 {
            RationService.instance.get { (_, error) in
                if let error = error {
                    self.showErrorAlert(title: ERROR_TITLE_DIARY_REQUEST_FAILED, message: error.message)
                } else {
                    self.updateView()
                }
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
            rationTableView.reloadData()
            rationInfoView.setupNutrition()
            navigationItem.title = date
        }
    }
    
    // handlers
    
    @objc func dataChangedHandle() {
        updateView()
    }
    
    @objc func rationViewTapHandle() {
        //disable mode change if nutrition not set (nothing to show anyway)
        guard RationService.instance.nutrition != nil else { return }
        
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
            if indexPath.row < ration.count {
                
                let isEditable = RationService.instance.isCurrentRationEditable()
                cell.updateViews(foodItem: ration[indexPath.row], editable: isEditable, incPortionHandler: { (id) in
                    RationService.instance.incPortion(id: id, completion: { (_, error) in
                        if let error = error {
                            self.showErrorAlert(title: ERROR_TITLE_UPDATE_FAILED, message: error.message)
                        }
                    })
                }) { (id) in
                    RationService.instance.decPortion(id: id, completion: { (success, error) in
                        if let error = error {
                            self.showErrorAlert(title: ERROR_TITLE_UPDATE_FAILED, message: error.message)
                        }
                    })
                }
                return cell
            }
        }
        return RationFoodCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !RationService.instance.isCurrentRationEditable() {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let removeAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: REMOVE) { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            RationService.instance.removeItem(index: indexPath.row) { (_, error) in
                if let error = error {
                    self.showErrorAlert(title: ERROR_TITLE_UPDATE_FAILED, message: error.message)
                }
            }
            
            success(true)
            self.rationTableView.reloadData()
        }
        
        if #available(iOS 13.0, *) {
            removeAction.image = REMOVE_IMG
        }
        removeAction.backgroundColor = EATHO_RED
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
extension RationVC: TabDelegate {
    func tabChanged(vc: UIViewController) {
        if vc as? RationVC != nil {
            RationService.instance.setCurrent(forISODate: nil)
        }
    }
}
