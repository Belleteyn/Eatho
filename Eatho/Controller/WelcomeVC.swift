//
//  ViewController.swift
//  Eatho
//
//  Created by Серафима Зыкова on 17/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.showNextScreen()
        })
    }
    
    private func showNextScreen() {
        if AuthService.instance.isLoggedIn {
            self.goToAvailable()
        } else {
            self.goToLogin()
        }
    }
    
    private func goToLogin() {
        performSegue(withIdentifier: TO_LOGIN_SEGUE, sender: self)
    }

    private func goToAvailable() {
        performSegue(withIdentifier: TO_AVAILABLE_SEGUE, sender: self)
    }

}

