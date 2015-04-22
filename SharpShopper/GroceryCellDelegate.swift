//
//  GroceryCellDelegate.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/15/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

protocol GroceryCellDelegate {

    func didSelectDisclosure(forGrocery grocery: Grocery)
    func didUpdatePurchaseValueForGrocery(grocery: Grocery, newValue: Bool)
    
}