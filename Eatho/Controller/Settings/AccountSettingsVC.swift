//
//  AccountSettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AccountSettingsVC: BaseVC {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLogin), name: NOTIF_AUTH_DATA_CHANGED, object: nil)
        
        signOutButton.addShadow(color: UIColor.black, opacity: 0.1, offset: CGSize(width: 0, height: 0))
    }
    
    @objc func updateLogin() {
        userNameLabel.text = AuthService.instance.email
    }

    @IBAction func signOutButtonPressed(_ sender: Any) {
        AuthService.instance.logOut()
        navigationController?.popViewController(animated: true)
    }
}
