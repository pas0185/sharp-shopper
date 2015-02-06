//
//  GroceryTableViewCell.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {

    var myGrocery: Grocery!
    
    @IBOutlet var buySwitch: UISwitch!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buySwitch.setOn(myGrocery.purchased, animated: false)
        nameLabel.text = myGrocery.name
        pointLabel.text = String(myGrocery.points)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
