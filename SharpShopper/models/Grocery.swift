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
    @NSManaged var isOnGroceryList: Bool
    @NSManaged var purchased: Bool
    
    @NSManaged var price: Double
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext?, itemID: String?, itemName: String?, itemDescription: String?, itemCategory: String?, itemImageURL: String?, purchased: Bool, price: Double?) -> Grocery {
        
        var myMoc = moc
        
        if myMoc == nil {
            println("Using a scrap managed object context")
            myMoc = NSManagedObjectContext()
        }
        
        if let entity = NSEntityDescription.entityForName("Grocery", inManagedObjectContext: myMoc!)
        {
        
            var newGrocery = NSManagedObject(entity: entity, insertIntoManagedObjectContext: nil) as! Grocery
            
    //        let newGrocery = NSEntityDescription.insertNewObjectForEntityForName("Grocery", inManagedObjectContext: moc) as! Grocery
            
            newGrocery.itemID = stripped(itemID)
            newGrocery.itemName = stripped(itemName)
            newGrocery.itemDescription = stripped(itemDescription)
            newGrocery.itemCategory = stripped(itemCategory)
            newGrocery.itemImageURL = stripped(itemImageURL)
            
            newGrocery.purchased = purchased
            newGrocery.price = price!
            
            return newGrocery
        }
        
        return Grocery()
    }
    
    class func stripped(string: String?) -> String {
        if let newString = string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) {
            return newString
        }
        
        return ""
    }
}
