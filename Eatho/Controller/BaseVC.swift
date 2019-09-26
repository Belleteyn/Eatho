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

}
