//
//  ActivityPickerVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 01/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class ActivityPickerVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Outlets
    @IBOutlet weak var activityPicker: UIPickerView!
    @IBOutlet var bgView: UIView!
    
    // picker data
    let activityPickerData = [
        "Minimal",
        "Light (training 3 times a week)",
        "Medium (intensive training 3 or more times a week)",
        "High (intensive training everyday)",
        "Extra (athletes)"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // picker
        activityPicker.dataSource = self
        activityPicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        bgView.addGestureRecognizer(tap)
    }

    // picker impl
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.activityPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: activityPickerData[row], attributes: [NSAttributedString.Key.foregroundColor : TEXT_COLOR, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("DID SELECT ROW \(row)")
        NotificationCenter.default.post(name: NOTIF_USER_ACTIVITY_LEVEL_CHANGED, object: row)
    }
    
    // tap handle
    
    @objc func tapHandle() {
        self.dismiss(animated: true, completion: nil)
    }
}
