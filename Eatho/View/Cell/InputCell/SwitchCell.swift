//
//  SwitchCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 11/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchItem: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(defaultSwitchPosition: Bool) {
        switchItem.setOn(defaultSwitchPosition, animated: true)
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        NotificationCenter.default.post(name: NOTIF_SETTINGS_AUTO_CALCULATION_CHANGED, object: nil, userInfo: ["isOn": switchItem.isOn])
    }
}
