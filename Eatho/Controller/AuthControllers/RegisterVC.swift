//
//  RegisterVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RegisterVC: BaseAuthVC {

    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var toRecoverButton: UIButton!
    
    var parentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Email", comment: "Auth"), attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        inputTextField.addTarget(self, action: #selector(textFieldChangeHander(_:)), for: .editingChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterNextVC {
            vc.email = inputTextField.text
        }
    }
    
    // Handlers
    
    @objc func textFieldChangeHander(_ textField: UITextField) {
        if let text = textField.text {
            confirmButton.isEnabled = StringValidation.isEmail(string: text)
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    // Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed() {
        guard let email = inputTextField.text, email != "" else { return }
        
        self.view.endEditing(false)
        spinner.startAnimating()
        
        AuthService.instance.checkEmailToRegistration(email: email) { (response, error) in
            self.spinner.stopAnimating()
            
            if response != nil {
                self.performSegue(withIdentifier: TO_PASSWORD_REGISTRATION_SEGUE, sender: self)
            } else if error != nil {
                self.errorLabel.text = ERROR_MSG_ALREADY_REGISTERED
                self.separatorView.backgroundColor = EATHO_RED
                self.toRecoverButton.isHidden = false
            }
        }
    }
    
    @IBAction func toRecoverPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true) {
            if let parent = self.parentVC as? LoginViewController {
                parent.pwdRecoveryPressed(self)
            }
        }
    }
}


extension RegisterVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorLabel.text = ""
        self.separatorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6588184932)
        self.toRecoverButton.isHidden = true
    }
}
