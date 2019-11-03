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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var codeInputField: UITextField!
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = TEXT_SENT_CONFIRMATION_CODE
        emailLabel.text = email
        helpLabel.text = TEXT_NOT_RECEIVED_CODE
        
        codeInputField.delegate = self
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

extension PasswordRecoveryCodeVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count != 4 {
            return false
        }
        
        if Int(text) == nil {
            return false
        }

        return true
    }
}
