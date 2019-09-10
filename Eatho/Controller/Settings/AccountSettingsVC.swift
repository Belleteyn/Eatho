//
//  AccountSettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AccountSettingsVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = AuthService.instance.userEmail
        signOutButton.addShadow(color: UIColor.black, opacity: 0.1, offset: CGSize(width: 0, height: 0))
    }

    @IBAction func signOutButtonPressed(_ sender: Any) {
        AuthService.instance.logOut()
        navigationController?.popViewController(animated: true)
    }
}
