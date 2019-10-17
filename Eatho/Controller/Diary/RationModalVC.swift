//
//  RationModalVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 16/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationModalVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chartView: RationChartView!
    @IBOutlet weak var tableView: UITableView!
    
    var ration: Ration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tap)
        
        guard let ration = self.ration else { return }
        guard let date = EathoDateFormatter.instance.date(fromString: ration.date) else { return }
        guard let nutrition = RationService.instance.nutrition else { return }
        
        titleLabel.text = EathoDateFormatter.instance.format(isoDate: date)
        chartView.initData(nutrition: nutrition, userNutrition: SettingsService.instance.userInfo.nutrition)
        chartView.layer.cornerRadius = 8
        chartView.clipsToBounds = true
        chartView.backgroundColor = UIColor.white
    }
    
    @objc func tapHandler() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pdfButtonPressed(_ sender: Any) {
        guard let title = titleLabel.text, let ration = ration?.ration else { return }
        
        let pdfRes = PdfCreator.instance.createDocument(title: title, username: AuthService.instance.email ?? "", ration: ration)
        
        if let pdf = pdfRes.0 {
            let vc = UIActivityViewController(
              activityItems: [pdf],
              applicationActivities: nil
            )

            present(vc, animated: true, completion: nil)
            
        } else if let error = pdfRes.1 {
            showErrorAlert(title: "Cannot create pfd".localized, message: error.localizedDescription)
            return
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        //todo: open in edit mode
    }
}

extension RationModalVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ration = ration else { return 0 }
        return ration.ration.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ration = ration else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rationFoodCell", for: indexPath) as? RationFoodCell else { return UITableViewCell() }
        
        cell.updateViews(foodItem: ration.ration[indexPath.row], editable: false, incPortionHandler: { (_) in
            
        }) { (_) in
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}
