//
//  Service.swift
//  Eatho
//
//  Created by Серафима Зыкова on 08/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

protocol Service {
    func reset()
    
    func get(completion: @escaping RequestCompletion)
}

extension Service {
    func subscribeLoggedIn(selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NOTIF_LOGGED_IN, object: nil)
    }
    
    func subscribeLoggedOut(selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NOTIF_LOGGED_OUT, object: nil)
    }
    
    func subscribeSignedOut(selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NOTIF_SIGNED_OUT, object: nil)
    }
}
