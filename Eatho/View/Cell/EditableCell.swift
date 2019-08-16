//
//  EditableCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 16/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class EditableCell: UITableViewCell {

    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initData(data: Nutrient) {
        infoLbl.text = data.name
        textField.text = "\(data.per100g)"
    }

}
