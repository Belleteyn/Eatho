//
//  RecentPurchasesCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 04/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RecentPurchasesCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    func updateView(name: String) {
        self.name.text = name
    }
}
