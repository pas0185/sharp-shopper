//
//  Grocery.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import Foundation
import CoreData

class Grocery: NSManagedObject {

    /* SupermarketAPI fields */
    var itemID: String?
    var itemName: String?
    var itemDescription: String?
    var itemCategory: String?
    var itemImageURL: String?
    
    /* User status fields */
    var purchased: Bool = false
    var price: Double?

    class func createInManagedObjectContext(moc: NSManagedObjectContext, itemID: String, itemName: String, itemDescription: String, itemCategory: String, itemImageURL: String, purchased: Bool, price: Double) -> Grocery {
        let newGrocery = NSEntityDescription.insertNewObjectForEntityForName("Grocery", inManagedObjectContext: moc) as! Grocery
        
        newGrocery.itemID = itemID
        newGrocery.itemName = itemName
        newGrocery.itemDescription = itemDescription
        newGrocery.itemCategory = itemCategory
        newGrocery.itemImageURL = itemImageURL
        
        newGrocery.purchased = purchased
        newGrocery.price = price
        
        return newGrocery
    }
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, grocery: Grocery) -> Grocery {
        
        let newGrocery = NSEntityDescription.insertNewObjectForEntityForName("Grocery", inManagedObjectContext: moc) as! Grocery
        
        newGrocery.itemID = grocery.itemID
        newGrocery.itemName = grocery.itemName
        newGrocery.itemDescription = grocery.itemDescription
        newGrocery.itemCategory = grocery.itemCategory
        newGrocery.itemImageURL = grocery.itemImageURL
        
        newGrocery.purchased = grocery.purchased
        newGrocery.price = grocery.price
        
        return newGrocery
    }
}
