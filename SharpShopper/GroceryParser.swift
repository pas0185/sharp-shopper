//
//  GroceryParser.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/14/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

class GroceryParser: NSObject {

    class func parseToDictionary(grocery: Grocery) -> Dictionary<String, String> {
        
        var dict =
        [
            /* SupermarketAPI fields */

            "itemID": grocery.itemID,
            "itemName": grocery.itemName,
            "itemDescription": grocery.itemDescription,
            "itemCategory": grocery.itemCategory,
            "itemImageURL": grocery.itemImageURL
        ]
        
        
        return dict
    }
}
