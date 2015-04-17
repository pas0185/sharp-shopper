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
    @NSManaged var itemID: String
    @NSManaged var itemName: String
    @NSManaged var itemDescription: String
    @NSManaged var itemCategory: String
    @NSManaged var itemImageURL: String
    
    /* User status fields */
    @NSManaged var purchased: Bool
    // TODO: make this a computed property
    // when modified, notify the delegate
    //
    //         self.delegate?.groceryListDataDidChange()
    //
    
    @NSManaged var price: Double

    var delegate: GroceryListUpdateDelegate?
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, itemID: String, itemName: String, itemDescription: String, itemCategory: String, itemImageURL: String, purchased: Bool, price: Double) -> Grocery {
        let newGrocery = NSEntityDescription.insertNewObjectForEntityForName("Grocery", inManagedObjectContext: moc) as! Grocery
        
        newGrocery.itemID = stripped(itemID)
        newGrocery.itemName = stripped(itemName)
        newGrocery.itemDescription = stripped(itemDescription)
        newGrocery.itemCategory = stripped(itemCategory)
        newGrocery.itemImageURL = stripped(itemImageURL)
        
        newGrocery.purchased = purchased
        newGrocery.price = price
        
        return newGrocery
    }
    
    class func stripped(string: String) -> String {
        var newString = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        println("Old string = \(string)\nNew string = \(newString)\n\n")
        return newString
    }
}
