//
//  BaseVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 24/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var tabChangeDelegate: TabDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Common subscriptions
        subscribeToSettingsError()
        
        tabBarController?.delegate = self
    }

    func openModalWithNavigation(identifier: String, completion: @escaping (_ vc: UIViewController) -> ()) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier) else { return }
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .custom
        
        self.navigationController?.present(navController, animated: true) {
            completion(vc)
        }
    }
}

extension BaseVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let nav = viewController as? UINavigationController {
            nav.popToRootViewController(animated: false)
        }
        
        if let delegate = tabChangeDelegate {
            delegate.tabChanged(vc: viewController)
        }
    }
}
