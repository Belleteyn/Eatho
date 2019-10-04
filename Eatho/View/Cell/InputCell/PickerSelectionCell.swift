//
//  PickerSelectionCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 12/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class PickerSelectionCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainLabel.text = NSLocalizedString("Activity level", comment: "Settings")
    }
    
    func setupView(type: String, description: String) {
        typeLabel.text = type
        descriptionLabel.text = description
    }
}
