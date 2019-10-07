//
//  LocalizationSettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class LocalizationSettingsVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension LocalizationSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedControlCell", for: indexPath) as? SegmentedControlCell {
            cell.setupView(title: NSLocalizedString("Weight measures", comment: "Settings"), activeSegmentedControlIndex: SettingsService.instance.userInfo.lbsMetrics ? 1 : 0) { (selectedIndex) in
                var info = SettingsService.instance.userInfo
                info.lbsMetrics = (selectedIndex == 1)
                SettingsService.instance.userInfo = info
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}
