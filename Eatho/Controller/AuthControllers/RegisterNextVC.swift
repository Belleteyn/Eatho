//
//  RegisterNextVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 26/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RegisterNextVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        inputTextField.delegate = self
        inputTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerPressed() {
        guard let email = email else { return }
        guard let password = inputTextField.text, password != "" else {
            errorLabel.text = ERROR_MSG_PASSWORD_MISSED
            separatorView.backgroundColor = EATHO_RED
            return
        }
        
        self.view.endEditing(false)
        spinner.startAnimating()
        
        AuthService.instance.register(email: email, password: password) { (success, error) in
            self.spinner.stopAnimating()
            
            if let error = error { //todo: may be network error
                self.errorLabel.text = ERROR_MSG_REGISTRATION_FAILED
                self.separatorView.backgroundColor = EATHO_RED
            } else {
                self.backButtonPressed(self)
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorLabel.text = ""
        self.separatorView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6588184932)
    }
}
