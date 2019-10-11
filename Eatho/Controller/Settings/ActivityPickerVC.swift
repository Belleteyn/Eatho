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
    
    var delegate: PickerViewIndexDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // picker
        activityPicker.dataSource = self
        activityPicker.delegate = self
        
        activityPicker.layer.cornerRadius = 6
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        bgView.addGestureRecognizer(tap)
        
        activityPicker.selectRow(SettingsService.instance.userInfo.activityIndex, inComponent: 0, animated: true)
    }

    // picker impl
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 46
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 46))
        let typeLabel = UILabel(frame: CGRect(x: 0, y: 6, width: pickerView.frame.width, height: 17))
        let infoLabel = UILabel(frame: CGRect(x: 0, y: 23, width: pickerView.frame.width, height: 15))
        
        typeLabel.textColor = TEXT_COLOR
        infoLabel.textColor = LIGHT_TEXT_COLOR
        
        typeLabel.text = SettingsService.instance.activityPickerData[row][0]
        infoLabel.text = SettingsService.instance.activityPickerData[row][1]
        
        typeLabel.font = UIFont.systemFont(ofSize: 17)
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        typeLabel.textAlignment = .center
        infoLabel.textAlignment = .center
        
        view.addSubview(typeLabel)
        view.addSubview(infoLabel)
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let delegate = delegate {
            delegate.indexChanged(index: row)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // tap handle
    
    @objc func tapHandle() {
        self.dismiss(animated: true, completion: nil)
    }
}
