//
//  ShoppingListCell.swift
//  Eatho
//
//  Created by Серафима Зыкова on 04/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    var selectionState = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionState = !selectionState
        selectionStateChangedHandle()
    }
    
    func updateView(name: String, selectionState: Bool) {
        self.name.text = name
        self.selectionState = selectionState
        selectionStateChangedHandle()
    }
    
    func selectionStateChangedHandle() {
        if selectionState {
            selectedButton.setImage(UIImage(named: "content_list_checked.png"), for: .normal)
        } else {
            selectedButton.setImage(UIImage(named: "content_list_unchecked.png"), for: .normal)
        }
    }

    @IBAction func selectionButtonClicked(_ sender: Any) {
        selectionState = !selectionState
        selectionStateChangedHandle()
    }
}
