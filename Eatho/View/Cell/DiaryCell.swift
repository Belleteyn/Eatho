//
//  DiaryCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 08/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class DiaryCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var caloriesInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(ration: Ration) {
        let today = Date()
        print(today)
        print(ration.date)
        
        let isoFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from: "\(ration.date)Z")!
        
        dateLbl.text = ration.date
        if date == today {
            imgView.image = UIImage(named: "content_today.png")
        } else if date < today {
            imgView.image = UIImage(named: "content_item_2.png")
        } else {
            imgView.image = UIImage(named: "content_item_4.png")
        }
    }

}
