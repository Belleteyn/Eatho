//
//  DiaryVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class DiaryVC: UIViewController {

    @IBOutlet weak var daysPicker: UIPickerView!
    @IBOutlet weak var diaryTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        daysPicker.delegate = self
        daysPicker.dataSource = self
        
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        spinner.hidesWhenStopped = true
        
        configureRefreshControl()
        
        RationService.instance.requestRation { (success, error) in
            self.diaryTableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataChangedHandle), name: NOTIF_RATION_DATA_CHANGED, object: nil)
    }
    
    func configureRefreshControl() {
        diaryTableView.refreshControl = UIRefreshControl()
        diaryTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        RationService.instance.requestRation { (success, error) in
            self.diaryTableView.reloadData()
            
            DispatchQueue.main.async {
                self.diaryTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func dataChangedHandle() {
        diaryTableView.reloadData()
    }
    
    @IBAction func advancePrepPressed(_ sender: Any) {
        spinner.startAnimating()
        RationService.instance.prepRation(forDays: daysPicker.selectedRow(inComponent: 0) + 1) { (success, error) in
            self.spinner.stopAnimating()
            if success {
                self.diaryTableView.reloadData()
            }
        }
    }
    
}

extension DiaryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(row + 1)", attributes: [NSAttributedString.Key.foregroundColor : TEXT_COLOR, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
    }
}

extension DiaryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RationService.instance.diary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell") as? DiaryCell {
            cell.updateView(ration: RationService.instance.diary[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: UIContextualAction.Style.normal, title: "Update") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            //todo
            success(true)
            self.diaryTableView.reloadData()
        }
        update.backgroundColor = EATHO_YELLOW
        
        let details = UIContextualAction(style: UIContextualAction.Style.normal, title: "Details") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            //todo
            success(true)
            self.diaryTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [details, update])
    }
}
