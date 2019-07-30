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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNextScreen), name: NOTIF_USER_DATA_CHANGED, object: nil)
        
        showNextScreen()
    }
    
    @objc private func showNextScreen() {
        //NOTE: not working without timer
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            if AuthService.instance.isLoggedIn {
                self.performSegue(withIdentifier: TO_AVAILABLE_SEGUE, sender: self)
            } else {
                self.performSegue(withIdentifier: TO_LOGIN_SEGUE, sender: self)
            }
        })
    }
}

