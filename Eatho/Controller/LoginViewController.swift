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
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
}
