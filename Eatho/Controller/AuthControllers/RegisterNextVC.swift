//
//  RegisterNextVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 26/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RegisterNextVC: BaseAuthVC {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Password", comment: "Auth"), attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        inputTextField.addTarget(self, action: #selector(textFieldChangedHandle(_:)), for: .editingChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        emailLabel.text = email
    }
    
    @objc func textFieldChangedHandle(_ textField: UITextField) {
        nextButton.isEnabled = (textField.text != "")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerPressed() {
        guard let email = email else { return }
        guard let password = inputTextField.text, password != "" else { return }
        
        self.view.endEditing(false)
        spinner.startAnimating()
        
        AuthService.instance.register(email: email, password: password) { (success, error) in
            self.spinner.stopAnimating()
            
            if let error = error { //todo: may be network error
                self.showErrorAlert(title: "ERROR".localized, message: error.localizedDescription)
            } 
        }
    }
}
