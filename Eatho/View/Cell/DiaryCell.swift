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
    
    var date: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedHandle))
        self.addGestureRecognizer(tap)
    }
    
    func updateView(ration: Ration) {
        guard let date = EathoDateFormatter.instance.date(fromString: ration.date) else { return }
        self.date = ration.date
        
        dateLbl.text = EathoDateFormatter.instance.format(isoDate: date)
        caloriesInfo.text = "\(round(ration.nutrition.calories)) \(KCAL)"
        
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
    
    @objc func tappedHandle() {
        guard let date = self.date else { return }
        
        if RationService.instance.currentDate != date {
            RationService.instance.setCurrent(forDate: date)
        }
        
        NotificationCenter.default.post(name: NOTIF_DIARY_OPEN, object: nil)
    }

}
