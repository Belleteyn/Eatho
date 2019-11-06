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
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = TEXT_ENTER_NEW_PASSWORD
        emailLabel.text = email
        
        textField.delegate = self
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
        guard let text = textField.text, let code = code, let email = email else { return }
        
        spinner.startAnimating()
        
        AuthService.instance.resetPasswordRequest(email: email, code: code, password: text, handler: { (response, error) in
            self.spinner.stopAnimating()
            if let error = error {
                self.showErrorAlert(title: "ERROR".localized, message: error.message)
            } else {
                self.backButtonPressed(self)
            }
        })
    }
}

extension PasswordRecoveryEnterPwdVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil && textField.text != "" {
            textField.resignFirstResponder()
            resetButtonPressed(self)
            return true
        }
        
        return false
    }
}
