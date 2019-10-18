//
//  DiaryVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class DiaryVC: BaseVC {

    @IBOutlet weak var diaryTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var prepButton: EathoButton!
    
    var days = 1
    var selectedRowIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        spinner.hidesWhenStopped = true
        
        configureRefreshControl()
        setupPrepLabel(days: days)
        prepButton.setTitle(PREPARE, for: .normal)
        
        if RationService.instance.diary.count == 0 {
            RationService.instance.get { (_, error) in
                if let error = error {
                    self.showErrorAlert(title: ERROR_TITLE_DIARY_REQUEST_FAILED, message: error.message)
                } else {
                    self.diaryTableView.reloadData()
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataChangedHandle), name: NOTIF_RATION_DATA_CHANGED, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? RationModalVC {
            guard selectedRowIndex >= 0 && selectedRowIndex < RationService.instance.diary.count else { return }
            destVC.setRation(ration: RationService.instance.diary[selectedRowIndex])
            destVC.openRationHandler = {
                self.tabBarController?.selectedIndex = 2
            }
        }
    }
    
    func configureRefreshControl() {
        diaryTableView.refreshControl = UIRefreshControl()
        diaryTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func setupPrepLabel(days: Int) {
        prepLabel.text = "\(days) \(DAYS)"
    }
    
    @objc func handleRefresh() {
        RationService.instance.get { (_, error) in
            DispatchQueue.main.async {
                self.diaryTableView.refreshControl?.endRefreshing()
            }
            
            if let error = error {
                self.showErrorAlert(title: ERROR_TITLE_DIARY_REQUEST_FAILED, message: error.message)
            } else {
                self.diaryTableView.reloadData()
            }
        }
    }
    
    @objc func dataChangedHandle() {
        diaryTableView.reloadData()
    }
    
    @IBAction func decButtonPressed(_ sender: Any) {
        if days > 1 {
            days -= 1
            setupPrepLabel(days: days)
        }
    }
    
    @IBAction func incButtonPressed(_ sender: Any) {
        if days < 7 {
            days += 1
            setupPrepLabel(days: days)
        }
    }
    
    @IBAction func prepButtonPressed(_ sender: Any) {
        spinner.startAnimating()
        RationService.instance.prepRation(forDays: days) { (_, error) in
            self.spinner.stopAnimating()
            
            if let error = error {
                self.showErrorAlert(title: ERROR_TITLE_DIARY_PREP_FAILED, message: error.message)
            } else {
                self.diaryTableView.reloadData()
            }
        }
    }
}

extension DiaryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RationService.instance.diary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < RationService.instance.diary.count else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell") as? DiaryCell {
            cell.updateView(ration: RationService.instance.diary[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRowIndex = indexPath.row
        performSegue(withIdentifier: "toModalDiaryRationSegue", sender: self)
    }
}
