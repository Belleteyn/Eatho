//
//  DiaryVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class DiaryVC: UIViewController {

    @IBOutlet weak var daysPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        daysPicker.delegate = self
        daysPicker.dataSource = self
    }
    
    @IBAction func advancePrepPressed(_ sender: Any) {
        
    }
    
}

extension DiaryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(row + 1)", attributes: [NSAttributedString.Key.foregroundColor : TEXT_COLOR, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])
    }
}
