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
        
        // Assign text to UILabels
        nameLabel.text = myGrocery.name
        pointLabel.text = String(myGrocery.points)
        
        // Assign state to the UISwitch
        buySwitch.setOn(myGrocery.purchased, animated: false)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func purchasedSwitchChanged(sender: AnyObject, forEvent event: UIEvent) {

        // If we flip the switch, flip myGrocery's purchased value
        
        myGrocery.purchased = buySwitch.on
    }
}
