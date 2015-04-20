//
//  ClientAPIDelegate.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/19/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation

protocol ClientAPIDelegate {
    
    func foundNetworkGroceries(groceryListData data: NSData)
}