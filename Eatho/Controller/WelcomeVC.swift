//
//  ViewController.swift
//  Eatho
//
//  Created by Серафима Зыкова on 17/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.goToAvailable()
        })
    }
    
    func goToLogin() {
        performSegue(withIdentifier: "loginFormSegue", sender: self)
    }

    func goToAvailable() {
        performSegue(withIdentifier: "availableScreenSegue", sender: self)
    }

}

