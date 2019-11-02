//
//  LoginVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 17/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class LoginViewController: BaseAuthVC, UITextFieldDelegate {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var loginSeparatorView: UIView!
    @IBOutlet weak var passwordSeparatorView: UIView!
    @IBOutlet weak var errorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxt.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Email", comment: "Auth"), attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Password", comment: "Auth"), attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        
        emailTxt.addTarget(self, action: #selector(textFieldChangeHandle(_:)), for: .editingChanged)
        passwordTxt.addTarget(self, action: #selector(textFieldChangeHandle(_:)), for: .editingChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeError()
        emailTxt.text = ""
        passwordTxt.text = ""
    }
    
    func setupPasswordError(message: String) {
        loginSeparatorView.backgroundColor = EATHO_RED
        passwordSeparatorView.backgroundColor = EATHO_RED
        errorMsg.text = message
    }
    
    func removeError() {
        loginSeparatorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6588184932)
        passwordSeparatorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6588184932)
        errorMsg.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterVC {
            vc.parentVC = self
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let pass = passwordTxt.text, passwordTxt.text != "" else { return }
        
        self.view.endEditing(false)
        
        spinner.startAnimating()
        AuthService.instance.login(email: email, password: pass, handler: { (_, error) in
            self.spinner.stopAnimating()
            
            if let error = error {
                if let error = error as? AuthError {
                    switch error {
                    case AuthError.keychain:
                        self.showErrorAlert(title: ERROR_TITLE_AUTH, message: ERROR_MSG_KEYCHAIN)
                    default:
                        self.setupPasswordError(message: ERROR_MSG_LOG_PASS_INVALID)
                    }
                } else {
                    self.showErrorAlert(title: ERROR_TITLE_NETWORK_UNREACHABLE, message: ERROR_MSG_NETWORK_UNREACHABLE)
                }
            } 
        })
    }
    
    @IBAction func pwdRecoveryPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_PWD_RECOVERY_SEGUE, sender: self)
    }
    
    // Handlers
    
    @objc func textFieldChangeHandle(_ textField: UITextField) {
        guard let email = emailTxt.text else { return }
        
        removeError()
        nextButton.isEnabled = (StringValidation.isEmail(string: email) && passwordTxt.text != "")
    }
}
