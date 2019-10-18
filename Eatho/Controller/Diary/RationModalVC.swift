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
    
    @IBOutlet weak var editButton: UIButton!
    
    private var ration: Ration?
    var openRationHandler: (() -> ())?
    
    private var summary: [(String, Double)] = [
        ("Calories".localized, 0.0),
        ("Proteins".localized, 0.0),
        ("Carbs".localized, 0.0),
        ("Sugars".localized, 0.0),
        ("Fiber".localized, 0.0),
        ("Fats".localized, 0.0),
        ("Trans".localized, 0.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tap)
        
        guard let ration = self.ration else { return }
        guard let date = ration.localizedDateStr else { return }
        guard let nutrition = RationService.instance.nutrition else { return }
        
        titleLabel.text = date
        chartView.initData(nutrition: nutrition, userNutrition: SettingsService.instance.userInfo.nutrition)
        chartView.layer.cornerRadius = 8
        chartView.clipsToBounds = true
        chartView.backgroundColor = UIColor.white
        
        if let date = ration.date {
            editButton.isHidden = (DateComparator.compareDateWithToday(date: date) < 0)
        }
    }
    
    func setRation(ration: Ration) {
        self.ration = ration
        
        let overall = ration.nutrition
        
        summary[0].1 = overall.calories
        summary[1].1 = overall.proteins
        summary[2].1 = overall.carbs
        summary[3].1 = overall.sugars
        summary[4].1 = overall.fiber
        summary[5].1 = overall.fats
        summary[6].1 = overall.trans
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
        guard let ration = self.ration, let handler = openRationHandler else { return }
        RationService.instance.setCurrent(forISODate: ration.isoDate)
        
        self.dismiss(animated: true) {
            handler()
        }
    }
}

extension RationModalVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Overall".localized
        case 1:
            return "Food list".localized
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ration = ration else { return 0 }
        
        switch section {
        case 0:
            return 7
        case 1:
            return ration.ration.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ration = ration else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)
            cell.textLabel?.textColor = TEXT_COLOR
            cell.detailTextLabel?.textColor = TEXT_COLOR
            
            let measure = indexPath.row == 0 ? KCAL : G
            cell.textLabel?.text = summary[indexPath.row].0
            cell.detailTextLabel?.text = "\(summary[indexPath.row].1.truncated()) \(measure)"
            
            return cell
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "rationFoodCell", for: indexPath) as? RationFoodCell {
                cell.updateViews(foodItem: ration.ration[indexPath.row])
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 42
        case 1:
            return 114
        default:
            return 0
        }
    }
}
