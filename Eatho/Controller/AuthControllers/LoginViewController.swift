//
//  LoginVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 17/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var loginSeparator: UIView!
    @IBOutlet weak var passwordSeparator: UIView!
    
    @IBOutlet weak var loginErrorMsg: UILabel!
    @IBOutlet weak var passwordErrorMsg: UILabel!
    
    @IBOutlet weak var itemsStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTxt.delegate = self
        passwordTxt.delegate = self
        
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap))
        view.addGestureRecognizer(tap)
        
        itemsStack.bindPositionToKeyboard()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else {
            loginErrorMsg.text = ERROR_MSG_LOGIN_MISSED
            loginSeparator.backgroundColor = EATHO_RED
            return
        }
        
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {
            passwordErrorMsg.text = ERROR_MSG_PASSWORD_MISSED
            passwordSeparator.backgroundColor = EATHO_RED
            return
        }
        
        self.view.endEditing(false)
        
        spinner.startAnimating()
        AuthService.instance.login(email: email, password: pass, handler: { (_, error) in
            self.spinner.stopAnimating()
            
            if let error = error {
                if let error = error as? AuthError {
                    switch error {
                    case AuthError.login:
                        self.loginErrorMsg.text = ERROR_MSG_USER_NOT_FOUND
                        self.loginSeparator.backgroundColor = EATHO_RED
                    case AuthError.password:
                        self.passwordErrorMsg.text = ERROR_MSG_INCORRECT_PASSWORD
                        self.passwordSeparator.backgroundColor = EATHO_RED
                    case AuthError.keychain:
                        self.showErrorAlert(title: "Auth error", message: "Cannot save credentials in keychain")
                    }
                } else {
                    self.showErrorAlert(title: ERROR_TITLE_NETWORK_UNREACHABLE, message: ERROR_MSG_NETWORK_UNREACHABLE)
                }
            } else {
                NotificationCenter.default.post(name: NOTIF_AUTH_DATA_CHANGED, object: nil)
            }
        })
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC {
            vc.parentVC = self
            present(vc, animated: true)
        }
    }
    
    @IBAction func pwdRecoveryPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_PWD_RECOVERY_SEGUE, sender: nil)
    }
    
    @objc func handleTap() {
        view.endEditing(false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxt {
            loginSeparator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6588184932)
            loginErrorMsg.text = ""
        } else if textField == passwordTxt {
            passwordSeparator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6588184932)
            passwordErrorMsg.text = ""
        }
    }
}
