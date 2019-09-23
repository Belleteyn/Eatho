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
    
    func showInfoAlert(title: String, message: String) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "alertVC") as? AlertVC else { return }
        vc.setupValues(title: title, description: message)
        vc.setTransparentBackground()
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .custom
        navController.modalTransitionStyle = .crossDissolve
        
        self.navigationController?.present(navController, animated: true) {
            
        }
    }
    
    func subscribeToSettingsError() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDataSyncErrorHandler(_:)), name: NOTIF_USER_DATA_SYNC_ERROR, object: nil)
    }
    
    @objc func userDataSyncErrorHandler(_ notification: Notification) {
        guard let data = notification.userInfo, let msg = data["error"] as? String else { return }
        showErrorAlert(title: "User data syncing error", message: msg)
    }
}
