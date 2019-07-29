//
//  RegisterVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 25/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var registerEmailTxt: UITextField!
    @IBOutlet weak var registerPasswordTxt: UITextField!
    @IBOutlet weak var confirmationPasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerEmailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        registerPasswordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        confirmationPasswordTxt.attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: [NSAttributedString.Key.foregroundColor : LOGIN_PLACEHOLDER_COLOR])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerPressed() {
        guard let email = registerEmailTxt.text , registerEmailTxt.text != "" else { return }
        guard let pass = registerPasswordTxt.text, registerPasswordTxt.text != "" && confirmationPasswordTxt.text == registerPasswordTxt.text else { return }
        self.view.endEditing(false)
        
        AuthService.instance.register(email: email, password: pass) { (success) in
            if (success) {
                self.performSegue(withIdentifier: UNWIND_TO_WELCOME, sender: nil)
            } else {
                print("registration failed")
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}
