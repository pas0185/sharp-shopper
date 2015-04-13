//
//  Grocery.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class Grocery: NSObject {


    var id: Int = 0
    var points: Int = 0
    var name: String = ""
    var purchased: Bool = false
    
    var price: Double = 0.00
    
    
    /* Below from SupermarketAPI fields */
    var itemID: String?
    var itemName: String?
    var itemDescription: String?
    var itemCategory: String?
    var itemImageURL: String?
    
}
