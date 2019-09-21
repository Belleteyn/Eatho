//
//  ErrorExtension.swift
//  Eatho
//
//  Created by Серафима Зыкова on 21/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "alertVC") as? AlertVC else { return }
        vc.setupValues(title: title, description: message)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .custom
        navController.modalTransitionStyle = .crossDissolve
        
        self.navigationController?.present(navController, animated: true) {
            
        }
    }
}
