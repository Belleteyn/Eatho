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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerPressed() {
        guard let email = registerEmailTxt.text , registerEmailTxt.text != "" else {
            return
        }
        guard let pass = registerPasswordTxt.text, registerPasswordTxt.text != "" else {
            return
        }
        
        AuthService.instance.register(email: email, password: pass) { (success) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("registration failed")
            }
        }
    }
}
