//
//  SegmentedControlCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 14/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SegmentedControlCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var control: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupView(title: String, activeSegmentedControlIndex active: Int) {
        mainLabel.text = title
        control.selectedSegmentIndex = active
    }
}
