//
//  AlertVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 21/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var titleVal = ""
    var descriptionVal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addShadow(color: UIColor.black, opacity: 0.2, offset: CGSize(width: 0, height: 0))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleVal
        descriptionLabel.text = descriptionVal
        
        animateOpen()
    }
    
    func setupValues(title: String, description: String) {
        self.titleVal = title
        self.descriptionVal = description
    }
    
    func setTransparentBackground() {
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateClose()
    }
    
    func animateOpen() {
        self.backgroundView.frame.origin.y = self.backgroundView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.backgroundView.frame.origin.y = self.backgroundView.frame.origin.y - 50
            
            Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.close), userInfo: nil, repeats: false)
        })
    }
    
    func animateClose() {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.backgroundView.frame.origin.y = self.backgroundView.frame.origin.y + 50
        })
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
