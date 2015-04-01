//
//  GroceryList.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 3/31/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class GroceryList: NSObject {
    
    private var groceryList: [Grocery] = []

    func addGrocery(grocery: Grocery) {
        self.groceryList.append(grocery)
    }
    
    func purchasedGroceries() -> [Grocery] {
        var purchasedList: [Grocery] = []
        
        for grocery in self.groceryList {
            if grocery.purchased {
                purchasedList.append(grocery)
            }
        }
        
        return purchasedList
    }
    
    func unpurchasedGroceries() -> [Grocery] {
        var unpurchasedList: [Grocery] = []
        
        for grocery in self.groceryList {
            if !grocery.purchased {
                unpurchasedList.append(grocery)
            }
        }
        
        return unpurchasedList
    }
    
   
}
