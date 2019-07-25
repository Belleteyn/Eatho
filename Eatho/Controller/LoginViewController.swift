//
//  LoginVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 17/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else {
            return
        }
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {
            return
        }
        
        AuthService.instance.login(email: email, password: pass) { (success) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("login failed")
            }
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_REGISTER_SEGUE, sender: nil)
    }
}
