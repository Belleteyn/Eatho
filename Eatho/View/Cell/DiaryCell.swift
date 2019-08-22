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
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: "\(ration.date)") else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        dateLbl.text = dateFormatter.string(from: date)
        
        let interval = date.timeIntervalSinceNow //in seconds
        let day = 24.0 * 60 * 60
        
        if interval > 0 {
            imgView.image = UIImage(named: "content_item_4.png")
        } else if day + interval >= 0 {
            imgView.image = UIImage(named: "content_today.png")
        } else {
            imgView.image = UIImage(named: "content_item_1.png")
        }
    }

}
