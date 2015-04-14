//
//  GroceryTableViewCell.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

protocol GroceryListUpdateDelegate {
    func changedPurchasedStatus()
}

class GroceryTableViewCell: UITableViewCell {

    private var myGrocery: Grocery!
    var delegate: GroceryListUpdateDelegate!
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet var nameLabel: UILabel?

    init(grocery: Grocery) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "")
        self.myGrocery = grocery
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let grocery = self.myGrocery {
            self.buyButton.selected = grocery.purchased
            self.nameLabel?.text = grocery.itemName
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignGrocery(grocery: Grocery) {
        self.myGrocery = grocery
    }
    
    @IBAction func buyButtonPressed(sender: UIButton) {
        
        sender.selected = !sender.selected
        self.myGrocery.purchased = sender.selected
        
        self.delegate.changedPurchasedStatus()
    
    }
}
