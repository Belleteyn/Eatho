//
//  EathoTabBarController.swift
//  Eatho
//
//  Created by Серафима Зыкова on 09/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class EathoTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(openRationHandler(_:)), name: NOTIF_DIARY_OPEN, object: nil)
    }
    
    func switchTab(to index: Int) {
        guard selectedIndex != index else { return }
        
        guard let fromView = selectedViewController?.view, let controllers = viewControllers, let toView = controllers[index].view else { return }
        
        view.isUserInteractionEnabled = false
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: {
            _ in
            self.selectedIndex = index
            self.view.isUserInteractionEnabled = true
        })
    }
    
    @objc func openRationHandler(_ notification: Notification) {
        switchTab(to: 2)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let controllers = viewControllers else { return false }
        
        if viewController == controllers[2] { //user selects Ration -> expects to see today ration
            RationService.instance.setCurrent(forISODate: nil)
        }
        
        return true
    }
}
