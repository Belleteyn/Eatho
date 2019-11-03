//
//  PasswordRecoveryCodeVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 01/11/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class PasswordRecoveryCodeVC: BaseAuthVC {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var codeInputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = PASSWORD_RESET_INFO_TEXT
        
        codeInputField.addTarget(self, action: #selector(textFieldChangedHandle(_:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        codeInputField.becomeFirstResponder()
    }
    
    @objc func textFieldChangedHandle(_ textField: UITextField) {
        if let text = textField.text {
            confirmButton.isEnabled = (text.count == 4)
        } else {
            confirmButton.isEnabled = false
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_PWD_SET_SEGUE, sender: self)
    }
}
