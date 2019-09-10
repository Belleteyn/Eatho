//
//  NutritionalSettingsVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class NutritionalSettingsVC: UIViewController {

//    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        scrollView.bindHeightToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        view.addGestureRecognizer(tap)
    }

    @objc func tapHandle() {
        view.endEditing(false)
    }
}

extension NutritionalSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Ration preferences"
        case 1:
            return "Auto calculation"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            let label = UILabel(frame: CGRect(x: footer.frame.minX, y: footer.frame.minY, width: footer.frame.width - 16, height: footer.frame.height - 8))
            
            label.textColor = EATHO_RED
            label.text = "Please set appropriate values"
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 14)
            
            footer.addSubview(label)
            return footer
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 180
        case 1:
            return 360
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "userNutritionPrefsCell", for: indexPath) as? UserNutritionPrefsCell {
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "autoNutritionPrefsCell", for: indexPath) as? AutoNutritionPrefsCell {
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    
}
