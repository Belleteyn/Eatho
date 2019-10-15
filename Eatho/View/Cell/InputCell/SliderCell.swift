//
//  SliderCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 13/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var textField: UITextField!
    
    typealias PercentageUpdateHandler = (Double, NutrientType) -> ()
    
    private var activeState = false
    private var nutrientType: NutrientType!
    
    var inpuFinishedDecimalHandler: NumberHandler?
    var updateHandler: PercentageUpdateHandler!
    
    var max = 100.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedHandler))
        self.addGestureRecognizer(tap)
    }

    func setupView(title: String, sliderValue val: Float, nutrientType: NutrientType, max: Double) {
        titleLabel.text = title
        textField.text = "\(val.truncated())"
        
        self.nutrientType = nutrientType
        self.max = max
        
        slider.setValue(val / 100, animated: true)
        slider.maximumValue = Float(max / 100)
        switch nutrientType {
        case .Proteins:
            slider.tintColor = EATHO_PROTEINS
        case .Carbs:
            slider.tintColor = EATHO_CARBS
        case .Fats:
            slider.tintColor = EATHO_FATS
        default:
            ()
        }
    }
    
    @objc func tappedHandler() {
        if activeState {
            textField.resignFirstResponder()
        } else {
            textField.becomeFirstResponder()
        }
        
        activeState = !activeState
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        textField.text = "\((slider.value * 100).truncated())"
        
        updateHandler(Double(slider.value) * 100, self.nutrientType)
    }
}

extension SliderCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text == "" {
            textField.text = "\((slider.value * 100).truncated())"
        }
        
        guard let val = Double(text.decimalized) else { return }
        if let inpuFinishedDecimalHandler = inpuFinishedDecimalHandler {
            inpuFinishedDecimalHandler(val)
            return
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextView) {
        guard let text = textField.text else { return }
        guard var val = Double(text.decimalized) else { return }
        
        print("text changed to val \(val)")
        
        if val < 0 {
            val = 0
        } else if val > max {
            val = max
        }
        
        print("upd slider to val \(val)")
        slider.setValue(Float(val) / 100, animated: true)
    }
}
