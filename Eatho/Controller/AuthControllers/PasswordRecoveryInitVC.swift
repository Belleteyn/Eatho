//
//  PasswordRecoveryVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 26/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class PasswordRecoveryInitVC: BaseAuthVC {

    @IBOutlet weak var emailInputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInputField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Email", comment: "Auth"), attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        emailInputField.addTarget(self, action: #selector(textFieldChangeHander(_:)), for: .editingChanged)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PasswordRecoveryCodeVC {
            vc.email = emailInputField.text
        }
    }
    
    @objc func textFieldChangeHander(_ textField: UITextField) {
        if let text = textField.text {
            confirmButton.isEnabled = StringValidation.isEmail(string: text)
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let email = emailInputField.text else { return }
        spinner.startAnimating()
        
        AuthService.instance.restorePasswordCodeRequest(email: email) { (response, error) in
            self.spinner.stopAnimating()
            if let error = error {
                self.showErrorAlert(title: "ERROR".localized, message: error.message)
            } else {
                self.performSegue(withIdentifier: TO_PWD_RESET_CODE_SEGUE, sender: self)
            }
        }
    }
}
