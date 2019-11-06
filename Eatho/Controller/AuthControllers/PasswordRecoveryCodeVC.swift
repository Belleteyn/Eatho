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
    
    @IBOutlet weak var textFieldUnderlineView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var email: String?
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = TEXT_SENT_CONFIRMATION_CODE
        emailLabel.text = email
        helpLabel.text = TEXT_NOT_RECEIVED_CODE
        errorLabel.text = WRONG_CODE_ERROR
        
        codeInputField.delegate = self
        codeInputField.addTarget(self, action: #selector(textFieldChangedHandle(_:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        codeInputField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PasswordRecoveryEnterPwdVC {
            vc.email = email
            vc.code = code
        }
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
        guard let text = codeInputField.text, let email = email else { return }
        code = text
        
        AuthService.instance.resetPasswordCodeRequest(email: email, code: text) { (response, error) in
            self.spinner.stopAnimating()
            if let error = error {
                print(error.code)
                if error.code == 500 {
                    self.errorLabel.isHidden = false
                    self.textFieldUnderlineView.backgroundColor = EATHO_RED
                } else {
                    self.showErrorAlert(title: "ERROR".localized, message: error.message)
                }
            } else {
                self.performSegue(withIdentifier: TO_PWD_SET_SEGUE, sender: self)
            }
        }
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let email = "eatho@support.com"
        
    }
}

extension PasswordRecoveryCodeVC: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.isHidden = true
        textFieldUnderlineView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6588184932)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count != 4 {
            return false
        }
        
        if Int(text) == nil {
            return false
        }

        textField.resignFirstResponder()
        nextPressed(self)
        return true
    }
}
