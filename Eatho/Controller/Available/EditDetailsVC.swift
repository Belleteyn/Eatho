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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func setupView(title: String) {
        titleLbl.text = title
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
