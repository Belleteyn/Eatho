//
//  RationVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationVC: OverviewVC {
    
    enum TableState {
        case Collapsed, Expanded
    }
    
    // Outlets
    @IBOutlet weak var rationTableView: UITableView!
    @IBOutlet weak var overviewTableView: UITableView!
    @IBOutlet weak var overviewCollapsedView: RationNutrientsView!
    
    @IBOutlet weak var overviewViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var overviewTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var ration: Ration?
    private var state = TableState.Expanded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabChangeDelegate = self
        
        rationTableView.delegate = self
        rationTableView.dataSource = self
        
        overviewTableView.delegate = self
        overviewTableView.dataSource = self
        
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
        
        let tableTap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        overviewTableView.addGestureRecognizer(tableTap)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        overviewCollapsedView.addGestureRecognizer(viewTap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
    }
    
    func updateView() {
        self.ration = RationService.instance.currentRation
        
        if let overall = ration?.nutrition {
            super.setupChartsData(overallNutrition: overall)
            overviewCollapsedView.setupUserData()
            overviewCollapsedView.setupNutrition(overallNureirion: overall)
            rationTableView.reloadData()
            overviewTableView.reloadData()
        }
        
        if let date = ration?.localizedDateStr {
            navigationItem.title = date
        }
    }
    
    func collapseTable() {
        guard state != .Collapsed else { return }
        
        state = .Collapsed
        let sectionsSet = IndexSet(integersIn: 0...1)
        overviewTableView.deleteSections(sectionsSet, with: UITableView.RowAnimation.top)

        overviewTableView.reloadData()
        
        UIView.animate(withDuration: 0.3) {
            self.overviewViewHeightConstraint.constant = 60
            self.overviewTableHeightConstraint.constant = 0
            
            self.view.layoutIfNeeded()
        }
    }
    
    func expandTable() {
        guard state != .Expanded else { return }

        state = .Expanded
        let sectionsSet = IndexSet(integersIn: 0...1)
        overviewTableView.insertSections(sectionsSet, with: .bottom)
        
        UIView.animate(withDuration: 0.3) {
            self.overviewViewHeightConstraint.constant = 0
            self.overviewTableHeightConstraint.constant = 360
            
            self.view.layoutIfNeeded()
        }
    }
    
    // handlers
    
    @objc func dataChangedHandle() {
        updateView()
    }
    
    @objc func tapHandler() {
        switch state {
        case .Collapsed:
            expandTable()
        case .Expanded:
            collapseTable()
        }
    }
    
    @objc func swipeHandler() {
        
    }
}

extension RationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == rationTableView {
            return 1
        } else if tableView == overviewTableView {
            switch state {
            case .Collapsed:
                return 0
            case .Expanded:
                return 2
            }
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ration = ration else { return 0 }
        
        if tableView == rationTableView {
            return ration.ration.count
        } else {
            switch state {
            case .Collapsed:
                return 0
            case .Expanded:
                switch section {
                case 0:
                    return chartsSectionSize
                case 1:
                    return overviewSectionSize
                default:
                    return 0
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == overviewTableView {
            switch indexPath.section {
            case 0:
                return dequeueChartCell(tableView, cellForRowAt: indexPath, cellIdentifier: "chartCell")
            case 1:
                return dequeueOverviewCell(tableView, cellForRowAt: indexPath, cellIdentifier: "overviewCell")
            default:
                return UITableViewCell()
            }
            
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "rationFoodCell") as? RationFoodCell {
                guard let ration = ration?.ration else { return RationFoodCell() }
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
        }
        

        return RationFoodCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == overviewTableView {
            return nil
        }
        
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
        if tableView == rationTableView {
            return 114
        } else {
            switch indexPath.section {
            case 0:
                return recommendedChartCellHeight * 0.75
            case 1:
                return recommendedOverviewCellHeight * 0.9
            default:
                return 0
            }
        }
    }
}

extension RationVC: TabDelegate {
    func tabChanged(vc: UIViewController) {
        if vc as? RationVC != nil {
            RationService.instance.setCurrent(forISODate: nil)
        }
    }
}

