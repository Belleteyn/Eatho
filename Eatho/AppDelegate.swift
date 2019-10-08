//
//  AppDelegate.swift
//  Eatho
//
//  Created by Серафима Зыкова on 17/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum AppMode {
        case None, Main, Auth
    }
    
    var window: UIWindow?
    private var openedMode: AppMode = .None

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = vc
        
        NotificationCenter.default.addObserver(self, selector: #selector(openMain), name: NOTIF_LOGGED_IN, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openAuth), name: NOTIF_SIGNED_OUT, object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AuthService.instance.invalidateToken()
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        openAppScreen()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @objc private func openMain() {
        guard openedMode != .Main else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()
        
        if openedMode == .Auth {
            if let keyWindow = UIApplication.shared.keyWindow {
                UIView.transition(with: keyWindow, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                    let oldState = UIView.areAnimationsEnabled
                    UIView.setAnimationsEnabled(false)
                    UIApplication.shared.keyWindow?.rootViewController = vc
                    UIView.setAnimationsEnabled(oldState)
                })
                
                openedMode = .Main
                return
            }
        }
        
        self.window?.rootViewController = vc
        
        openedMode = .Main
    }
    
    @objc private func openAuth() {
        guard openedMode != .Auth else { return }
        
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()
        
        if openedMode == .Main {
            if let keyWindow = UIApplication.shared.keyWindow {
                UIView.transition(with: keyWindow, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                    let oldState = UIView.areAnimationsEnabled
                    UIView.setAnimationsEnabled(false)
                    UIApplication.shared.keyWindow?.rootViewController = vc
                    UIView.setAnimationsEnabled(oldState)
                })
                
                openedMode = .Auth
                return
            }
        }
        
        self.window?.rootViewController = vc
        openedMode = .Auth
    }
    
    @objc private func openAppScreen() {
        AuthService.instance.login { (_, error) in
            if error != nil {
                self.openAuth()
            } else {
                self.openMain()
            }
        }
    }
}

