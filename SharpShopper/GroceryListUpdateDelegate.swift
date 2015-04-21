//
//  GroceryListUpdateDelegate.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/15/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

protocol GroceryListUpdateDelegate {
    
    // TODO
    func didAddToList(grocery: Grocery)
    func didPurchase(grocery: Grocery)
    func didUnPurchase(grocery: Grocery)
    
    
    
    func groceryListDataDidChange()
    func didChooseGrocery(grocery: Grocery)
}