//
//  EditDetailsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 16/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class EditDetailsVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var availableTxtField: UITextField!
    @IBOutlet weak var minTxtField: UITextField!
    @IBOutlet weak var maxTxtField: UITextField!
    @IBOutlet weak var deltaTxtField: UITextField!
    
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupView(title: String, id: String) {
        titleLbl.text = title
        self.id = id
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        DataService.instance.updateFood(id: id!, available: availableTxtField.text != nil ? Double(availableTxtField.text!) : nil, min: minTxtField.text != nil ? Int(minTxtField.text!) : nil, max: maxTxtField.text != nil ? Int(maxTxtField.text!) : nil, delta: deltaTxtField.text != nil ? Double(deltaTxtField.text!) : nil) {(success) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("failed to update user data")
            }
        }
    }
}
