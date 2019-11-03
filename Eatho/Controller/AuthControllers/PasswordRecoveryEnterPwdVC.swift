//
//  PasswordRecoveryEnterPwdVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 01/11/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class PasswordRecoveryEnterPwdVC: BaseAuthVC {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = ""
        emailLabel.text = email
        
        textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Password", comment: "Auth"), attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        
        textField.addTarget(self, action: #selector(textFieldChangeHandle(_:)), for: .editingChanged)
        textField.becomeFirstResponder()
    }
    
    @objc func textFieldChangeHandle(_ textField: UITextField) {
        confirmButton.isEnabled = textField.text != nil && textField.text != ""
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        spinner.startAnimating()
        
        //todo request
    }
}
