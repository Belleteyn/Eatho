//
//  BaseVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 24/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Common subscriptions
        subscribeToSettingsError()
    }

    func openModal(identifier: String, completion: @escaping (_ vc: UIViewController) -> ()) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier) else { return }
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .custom
        
        self.navigationController?.present(navController, animated: true) {
            completion(vc)
        }
    }
}
