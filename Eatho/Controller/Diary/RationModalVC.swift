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
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    
    private var ration: Ration?
    var openRationHandler: (() -> ())?
    
    private var summary: [(String, Double)] = [
        ("Sugars".localized, 0.0),
        ("Fiber".localized, 0.0),
        ("Trans".localized, 0.0)
    ]
    
    private var chartsData: [NutrientData] = [
        NutrientData(name: "Calories".localized, measure: "\(KCAL)", color: EATHO_MAIN_COLOR),
        NutrientData(name: "Proteins".localized, measure: "\(G)", color: EATHO_PROTEINS),
        NutrientData(name: "Carbs".localized, measure: "\(G)", color: EATHO_CARBS),
        NutrientData(name: "Fats".localized, measure: "\(G)", color: EATHO_FATS)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        guard let ration = self.ration else { return }
        guard let date = ration.localizedDateStr else { return }
        
        titleLabel.text = date
        
        if let date = ration.date {
            editButton.isHidden = (DateComparator.compareDateWithToday(date: date) < 0)
        }
    }
    
    func setRation(ration: Ration) {
        self.ration = ration
        
        let overall = ration.nutrition
        
        summary[0].1 = overall.sugars
        summary[1].1 = overall.fiber
        summary[2].1 = overall.trans
        
        chartsData[0].value = overall.calories
        chartsData[0].expectedValue = SettingsService.instance.userInfo.nutrition.calories
        chartsData[1].value = overall.proteins
        chartsData[1].expectedValue = SettingsService.instance.userInfo.nutrition.proteins["g"] ?? 0
        chartsData[2].value = overall.carbs
        chartsData[2].expectedValue = SettingsService.instance.userInfo.nutrition.carbs["g"] ?? 0
        chartsData[3].value = overall.fats
        chartsData[3].expectedValue = SettingsService.instance.userInfo.nutrition.fats["g"] ?? 0
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Overall".localized
        case 2:
            return "Food list".localized
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ration = ration else { return 0 }
        
        switch section {
        case 0:
            return chartsData.count
        case 1:
            return summary.count
        case 2:
            return ration.ration.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ration = ration else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "chartCell", for: indexPath) as? ChartCell {
                let data = chartsData[indexPath.row]
                cell.updateViews(typename: data.name, measure: data.measure, value: data.value, expectedValue: data.expectedValue, color: data.color)
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)
            cell.textLabel?.textColor = TEXT_COLOR
            cell.detailTextLabel?.textColor = TEXT_COLOR
            
            let measure = indexPath.row == 0 ? KCAL : G
            cell.textLabel?.text = summary[indexPath.row].0
            cell.detailTextLabel?.text = "\(summary[indexPath.row].1.truncated()) \(measure)"
            
            return cell
        case 2:
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
            return 58
        case 1:
            return 38
        case 2:
            return 114
        default:
            return 0
        }
    }
}
