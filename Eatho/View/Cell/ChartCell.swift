//
//  ChartCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 18/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell {

    @IBOutlet weak var chart: SingleValuePieChart!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valuesLabel: UILabel!
    @IBOutlet weak var expectedValuesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateViews(typename: String, measure: String, value: Double, expectedValue: Double, color: UIColor) {
        let percentValue = value * 100 / expectedValue
        chart.initData(percentValue: percentValue, color: color)
        descriptionLabel.text = "\(typename): \(percentValue.truncated())%"
        valuesLabel.text = "\(value.truncated())"
        expectedValuesLabel.text = "/\(expectedValue.truncated()) \(measure)"
    }
}
