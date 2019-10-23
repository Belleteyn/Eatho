//
//  RationModalVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 16/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class RationModalVC: OverviewVC {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    
    private var ration: Ration?
    var openRationHandler: (() -> ())?
    
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
        super.setupChartsData(overallNutrition: ration.nutrition)
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
            return chartsSectionSize
        case 1:
            return overviewSectionSize
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
            return dequeueChartCell(tableView, cellForRowAt: indexPath, cellIdentifier: "chartCell")
        case 1:
            return dequeueOverviewCell(tableView, cellForRowAt: indexPath, cellIdentifier: "summaryCell")
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
            return recommendedChartCellHeight
        case 1:
            return recommendedOverviewCellHeight
        case 2:
            return 114
        default:
            return 0
        }
    }
}
