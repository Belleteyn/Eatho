//
//  BaseAuthVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 02/11/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class BaseAuthVC: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var itemsStack: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isEnabled = false
        spinner.hidesWhenStopped = true
        itemsStack.bindPositionToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}
