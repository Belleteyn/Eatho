//
//  RegisterVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var toRecoverButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var parentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        inputTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed() {
        guard let email = inputTextField.text, email != "" else {
            errorLabel.text = ERROR_MSG_LOGIN_MISSED
            separatorView.backgroundColor = EATHO_RED
            return
        }
        
        self.view.endEditing(false)
        spinner.startAnimating()
        
        AuthService.instance.checkEmailToRegistration(email: email) { (success, error) in
            self.spinner.stopAnimating()
            
            if let error = error { //todo: may be network error
                self.errorLabel.text = ERROR_MSG_ALREADY_REGISTERED
                self.separatorView.backgroundColor = EATHO_RED
                self.toRecoverButton.isHidden = false
            } else {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterNextVC") as? RegisterNextVC {
                    vc.email = email
                    self.present(vc, animated: true)
                }
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
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorLabel.text = ""
        self.separatorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6588184932)
        self.toRecoverButton.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextPressed()
        return true
    }
}
