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
    }
    
    func updateView(ration: Ration) {
        guard let date = ration.date, let localizedDateStr = ration.localizedDateStr else { return }
        
        dateLbl.text = localizedDateStr
        caloriesInfo.text = "\(round(ration.nutrition.calories)) \(KCAL)"
        
        let comparison = DateComparator.compareDateWithToday(date: date)
        if comparison > 0 {
            imgView.image = UIImage(named: "content_item_4.png")
        } else if comparison == 0 {
            imgView.image = UIImage(named: "content_today.png")
        } else {
            imgView.image = UIImage(named: "content_item_1.png")
        }
    }
}
